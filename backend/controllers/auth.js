import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { randomBytes, createHash } from 'crypto';

import {
    obtenerUsuarioPorEmail,
    obtenerUsuarioPorId,
    crearCodigoRecuperacion,
    obtenerCodigoRecuperacion,
    marcarCodigoUsado,
    actualizarUsuario
} from '../models/user.js';

import {
    crearRefreshTokenBD,
    obtenerRefreshTokenBD,
    revocarRefreshTokenBD
} from '../models/refreshToken.js';

import { enviarCodigoRecuperacion } from '../utils/sendEmail.js';

// Generar el hash del Refresh Token.
const generarHash = (token) => {
    return createHash('sha256').update(token).digest('hex');
};

// Crear Access Token y Refresh Token.
 export const generarTokens = async (usuario) => {

    const token = jwt.sign(
        {
            id: usuario.id,
            email: usuario.email,
            rol: usuario.rol
        },
        process.env.JWT_SECRET,
        { expiresIn: '2h' }
    );

    const refreshToken = randomBytes(64).toString('hex');

    const expiresAt = new Date(
        Date.now() + 90 * 24 * 60 * 60 * 1000
    ).toISOString();

    const { error } = await crearRefreshTokenBD(
        usuario.id,
        generarHash(refreshToken),
        expiresAt
    );

    if (error) {
        console.error('Error al guardar el Refresh Token:', error);
        throw new Error('No se pudo guardar la sesión en el servidor');
    }

    return { token, refreshToken };
};

// Iniciar sesión.
export const iniciarSesion = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({
                error: 'Email y contraseña son requeridos'
            });
        }

        const { data: usuario, error } =
            await obtenerUsuarioPorEmail(email);

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

        if (!usuario.isVerified) {
            return res.status(403).json({
                error: 'Tu cuenta no ha sido verificada. Por favor, ingresa el código enviado a tu correo antes de iniciar sesión.'
            });
        }

        const { token, refreshToken } =
            await generarTokens(usuario);

        return res.status(200).json({
            message: 'Inicio de sesión exitoso',
            token,
            refreshToken,
            usuario: {
                id: usuario.id,
                nombre: usuario.nombre,
                email: usuario.email,
                telefono: usuario.telefono,
                rol: usuario.rol,
                avatar: usuario.avatar ?? null,
                isVerified: usuario.isVerified
            }
        });

    } catch (error) {
        console.error('Error en iniciarSesion:', error);

        return res.status(500).json({
            error: error.message
        });
    }
};

// Renovar sesión.
export const renovarSesion = async (req, res) => {
    try {
        const { refreshToken } = req.body;

        if (!refreshToken) {
            return res.status(400).json({
                error: 'El Refresh Token es requerido'
            });
        }

        const hash = generarHash(refreshToken);

        const { data: sesion, error } =
            await obtenerRefreshTokenBD(hash);

        if (error) {
            throw error;
        }

        if (!sesion || sesion.revoked_at) {
            return res.status(401).json({
                error: 'La sesión no es válida. Inicia sesión nuevamente.'
            });
        }

        if (new Date(sesion.expires_at).getTime() <= Date.now()) {
            await revocarRefreshTokenBD(sesion.id);

            return res.status(401).json({
                error: 'La sesión ha expirado. Inicia sesión nuevamente.'
            });
        }

        // Buscar al usuario mediante su ID.
        const { data: usuario, error: errorUsuario } =
            await obtenerUsuarioPorId(sesion.usuario_id);

        if (errorUsuario || !usuario) {
            return res.status(401).json({
                error: 'No se encontró el usuario de esta sesión.'
            });
        }

        // Revocar el token anterior antes de emitir uno nuevo.
        const { data: revocado, error: errorRevocacion } =
            await revocarRefreshTokenBD(sesion.id);

        if (errorRevocacion) {
            throw errorRevocacion;
        }

        if (!revocado) {
            return res.status(401).json({
                error: 'La sesión ya fue utilizada. Inicia sesión nuevamente.'
            });
        }

        const { token, refreshToken: nuevoRefreshToken } =
            await generarTokens(usuario);

        return res.status(200).json({
            token,
            refreshToken: nuevoRefreshToken
        });

    } catch (error) {
        console.error('Error en renovarSesion:', error);

        return res.status(500).json({
            error: 'No se pudo renovar la sesión.'
        });
    }
};

// Cerrar sesión.
export const cerrarSesion = async (req, res) => {
    try {
        const { refreshToken } = req.body;

        if (refreshToken) {
            const hash = generarHash(refreshToken);

            const { data: sesion, error } =
                await obtenerRefreshTokenBD(hash);

            if (error) {
                throw error;
            }

            if (sesion && !sesion.revoked_at) {
                const { error: errorRevocacion } =
                    await revocarRefreshTokenBD(sesion.id);

                if (errorRevocacion) {
                    throw errorRevocacion;
                }
            }
        }

        return res.status(200).json({
            message: 'Sesión cerrada correctamente'
        });

    } catch (error) {
        console.error('Error en cerrarSesion:', error);

        return res.status(500).json({
            error: 'No se pudo cerrar la sesión'
        });
    }
};

// Solicitar código de recuperación.
export const solicitarRecuperacion = async (req, res) => {
    try {
        const { email } = req.body;

        if (!email) {
            return res.status(400).json({
                error: 'El email es requerido'
            });
        }

        const { data: usuario, error } =
            await obtenerUsuarioPorEmail(email);

        if (error || !usuario) {
            return res.status(404).json({
                error: 'No existe un usuario con ese email'
            });
        }

        const codigo = Math.floor(
            100000 + Math.random() * 900000
        ).toString();

        const expiresAt = new Date(
            Date.now() + 10 * 60 * 1000
        ).toISOString();

        const { error: errorCodigo } =
            await crearCodigoRecuperacion({
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
        console.error('Error en solicitarRecuperacion:', error);

        return res.status(500).json({
            error: error.message
        });
    }
};

// Restablecer contraseña.
export const restablecerContrasena = async (req, res) => {
    try {
        const {
            email,
            codigo,
            nuevaPassword
        } = req.body;

        if (!email || !codigo || !nuevaPassword) {
            return res.status(400).json({
                error: 'Email, código y nueva contraseña son requeridos'
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
        } = await obtenerCodigoRecuperacion(
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

        const {
            error: errorActualizacion
        } = await actualizarUsuario(
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
        console.error('Error en restablecerContrasena:', error);

        return res.status(500).json({
            error: error.message
        });
    }
};
