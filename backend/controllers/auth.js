import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

import {
    obtenerUsuarioPorEmail,
    crearCodigoRecuperacion,
    obtenerCodigoRecuperacion,
    marcarCodigoUsado,
    actualizarUsuario
} from '../models/user.js';

import { enviarCodigoRecuperacion } from '../utils/sendEmail.js';

// Iniciar sesión
export const iniciarSesion = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({
                error: 'Email y contraseña son requeridos'
            });
        }

        const { data: usuario, error } = await obtenerUsuarioPorEmail(email);

        if (error || !usuario) {
            return res.status(401).json({
                error: 'Email o contraseña incorrectos'
            });
        }

        const passwordValida = await bcrypt.compare(
            password,
            usuario.password
        );

        if (!passwordValida) {
            return res.status(401).json({
                error: 'Email o contraseña incorrectos'
            });
        }

        const token = jwt.sign(
            {
                id: usuario.id,
                email: usuario.email,
                rol: usuario.rol
            },
            process.env.JWT_SECRET,
            {
                expiresIn: '2h'
            }
        );

        return res.status(200).json({
            message: 'Inicio de sesión exitoso',
            token,
            usuario: {
                id: usuario.id,
                nombre: usuario.nombre,
                email: usuario.email,
                telefono: usuario.telefono,
                rol: usuario.rol
            }
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

// Solicitar código de recuperación
export const solicitarRecuperacion = async (req, res) => {
    try {
        const { email } = req.body;

        if (!email) {
            return res.status(400).json({
                error: 'El email es requerido'
            });
        }

        const { data: usuario, error } = await obtenerUsuarioPorEmail(email);

        if (error || !usuario) {
            return res.status(404).json({
                error: 'No existe un usuario con ese email'
            });
        }

        const codigo = Math.floor(100000 + Math.random() * 900000).toString();

        const expiresAt = new Date(
            Date.now() + 10 * 60 * 1000
        ).toISOString();

        const { error: errorCodigo } = await crearCodigoRecuperacion({
            usuario_id: usuario.id,
            codigo,
            expires_at: expiresAt,
            usado: false
        });

        if (errorCodigo) {
            return res.status(500).json({
                error: 'No se pudo generar el código de recuperación'
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
export const restablecerContrasena = async (req, res) => {
    try {
        const { email, codigo, nuevaPassword } = req.body;

        if (!email || !codigo || !nuevaPassword) {
            return res.status(400).json({
                error: 'Email, código y nueva contraseña son requeridos'
            });
        }

        const { data: usuario, error: errorUsuario } =
            await obtenerUsuarioPorEmail(email);

        if (errorUsuario || !usuario) {
            return res.status(404).json({
                error: 'Usuario no encontrado'
            });
        }

        const { data: codigoValido, error: errorCodigo } =
            await obtenerCodigoRecuperacion(
                usuario.id,
                codigo
            );

        if (errorCodigo || !codigoValido) {
            return res.status(400).json({
                error: 'El código es incorrecto o ha expirado'
            });
        }

        const passwordHash = await bcrypt.hash(
            nuevaPassword,
            10
        );

        const { error: errorActualizacion } =
            await actualizarUsuario(
                usuario.id,
                {
                    password: passwordHash
                }
            );

        if (errorActualizacion) {
            return res.status(500).json({
                error: 'No se pudo actualizar la contraseña'
            });
        }

        await marcarCodigoUsado(codigoValido.id);

        return res.status(200).json({
            message: 'Contraseña actualizada correctamente'
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};
