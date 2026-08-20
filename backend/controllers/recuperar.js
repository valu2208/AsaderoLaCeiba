import bcrypt from 'bcrypt';
import {
    obtenerUsuarioPorEmail,
    invalidarCodigosAnteriores,
    crearCodigoRecuperacion,
    obtenerCodigoValido,
    actualizarPassword,
    marcarCodigoUsado
} from '../models/recuperar.js';

import { enviarCodigoRecuperacion } from '../utils/sendEmail.js';

// Solicitar código de recuperación
export const solicitarRecuperacion = async (req, res) => {
    try {
        const { email } = req.body;

        if (!email) {
            return res.status(400).json({
                error: 'El correo es requerido'
            });
        }

        const { data: usuario, error: errorUsuario } =
            await obtenerUsuarioPorEmail(email);

        if (errorUsuario || !usuario) {
            return res.status(404).json({
                error: 'No existe un usuario con ese correo'
            });
        }

        // Invalidar códigos anteriores
        await invalidarCodigosAnteriores(usuario.id);

        // Generar código de 6 dígitos
        const codigo = Math.floor(
            100000 + Math.random() * 900000
        ).toString();

        // Expira en 10 minutos
        const expires_at = new Date(
            Date.now() + 10 * 60 * 1000
        ).toISOString();

        const { error: errorCodigo } =
            await crearCodigoRecuperacion({
                usuario_id: usuario.id,
                codigo,
                expires_at
            });

        if (errorCodigo) {
            return res.status(500).json({
                error: errorCodigo.message
            });
        }

        await enviarCodigoRecuperacion(
            usuario.email,
            usuario.nombre,
            codigo
        );

        return res.status(200).json({
            message: 'Código de recuperación enviado al correo'
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};


// Restablecer contraseña
export const restablecerPassword = async (req, res) => {
    try {
        const {
            email,
            codigo,
            nuevaPassword
        } = req.body;

        if (!email || !codigo || !nuevaPassword) {
            return res.status(400).json({
                error: 'Correo, código y nueva contraseña son requeridos'
            });
        }

        if (nuevaPassword.length < 6) {
            return res.status(400).json({
                error: 'La contraseña debe tener mínimo 6 caracteres'
            });
        }

        const {
            data: usuario,
            error: errorUsuario
        } = await obtenerUsuarioPorEmail(email);

        if (errorUsuario || !usuario) {
            return res.status(404).json({
                error: 'Usuario no encontrado'
            });
        }

        const {
            data: codigoValido,
            error: errorCodigo
        } = await obtenerCodigoValido(
            usuario.id,
            codigo
        );

        if (errorCodigo) {
            return res.status(500).json({
                error: errorCodigo.message
            });
        }

        if (!codigoValido) {
            return res.status(400).json({
                error: 'Código inválido, usado o expirado'
            });
        }

        const passwordHash = await bcrypt.hash(
            nuevaPassword,
            10
        );

        const {
            data: usuarioActualizado,
            error: errorPassword
        } = await actualizarPassword(
            usuario.id,
            passwordHash
        );

        if (errorPassword) {
            return res.status(500).json({
                error: errorPassword.message
            });
        }

        await marcarCodigoUsado(codigoValido.id);

        return res.status(200).json({
            message: 'Contraseña actualizada correctamente',
            usuario: usuarioActualizado
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};