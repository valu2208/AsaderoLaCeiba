import jwt from 'jsonwebtoken';
import { OAuth2Client } from 'google-auth-library';

import {
    obtenerUsuarioPorEmail,
    crearUsuarioGoogle,
    actualizarUsuario
} from '../models/user.js';

const client = new OAuth2Client(
    process.env.GOOGLE_CLIENT_ID
);

export const autenticarConGoogle = async (req, res) => {
    try {
        const { idToken } = req.body;

        if (!idToken) {
            return res.status(400).json({
                error: 'El idToken de Google es requerido'
            });
        }

        // Validar el token con Google
        const ticket = await client.verifyIdToken({
            idToken,
            audience: process.env.GOOGLE_CLIENT_ID
        });

        const payload = ticket.getPayload();

        const {
            sub: googleId,
            email,
            name: nombre,
            picture: avatar
        } = payload;

        // Buscar si el usuario ya existe
        const {
            data: usuarioExistente,
            error: errorBusqueda
        } = await obtenerUsuarioPorEmail(email);

        if (errorBusqueda && errorBusqueda.code !== 'PGRST116') {
            return res.status(500).json({
                error: 'Error al consultar el usuario'
            });
        }

        let usuarioFinal;

        if (usuarioExistente) {

            // El usuario ya existe
            usuarioFinal = usuarioExistente;

            const camposActualizar = {};

            if (!usuarioExistente.googleId) {
                camposActualizar.googleId = googleId;
            }

            if (!usuarioExistente.avatar && avatar) {
                camposActualizar.avatar = avatar;
            }

            if (!usuarioExistente.isVerified) {
                camposActualizar.isVerified = true;
            }

            if (Object.keys(camposActualizar).length > 0) {
                const {
                    data: usuarioActualizado,
                    error: errorActualizacion
                } = await actualizarUsuario(
                    usuarioExistente.id,
                    camposActualizar
                );

                if (errorActualizacion) {
                    return res.status(500).json({
                        error: 'No se pudo actualizar el usuario'
                    });
                }

                usuarioFinal = usuarioActualizado;
            }

        } else {

            // Crear usuario nuevo con Google
            const {
                data: nuevoUsuario,
                error: errorCrear
            } = await crearUsuarioGoogle({
                nombre,
                email,
                googleId,
                avatar,
                rol: 'usuario'
            });

            if (errorCrear) {
                return res.status(500).json({
                    error: 'Error al registrar el usuario con Google',
                    detalle: errorCrear.message
                });
            }

            usuarioFinal = nuevoUsuario;
        }

        // Crear JWT de nuestra aplicación
        const token = jwt.sign(
            {
                id: usuarioFinal.id,
                email: usuarioFinal.email,
                rol: usuarioFinal.rol.toLowerCase()
            },
            process.env.JWT_SECRET,
            {
                expiresIn: '2h'
            }
        );

        return res.status(200).json({
            message: usuarioExistente
                ? 'Inicio de sesión exitoso con Google'
                : 'Registro exitoso con Google',
            token,
            usuario: {
                id: usuarioFinal.id,
                nombre: usuarioFinal.nombre,
                email: usuarioFinal.email,
                telefono: usuarioFinal.telefono || null,
                rol: usuarioFinal.rol,
                isVerified: usuarioFinal.isVerified,
                avatar: usuarioFinal.avatar || avatar || null
            }
        });

    } catch (error) {
        console.error('Error en autenticarConGoogle:', error);

        return res.status(401).json({
            error: 'Token de Google inválido o expirado'
        });
    }
};