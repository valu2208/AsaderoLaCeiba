
import { generarTokens } from './auth.js';
import { OAuth2Client } from 'google-auth-library';
import { crearNotificacion } from '../models/notificacion.js';
 
import {
    obtenerUsuarioPorEmail,
    crearUsuarioGoogle,
    actualizarUsuario
} from '../models/user.js';
 
// IDs de cliente web aceptados (el de Firebase que usa la app + el de la variable de entorno)
const GOOGLE_CLIENT_IDS = [
    '978670292562-6f3qglp23eod82ig7vcj1h3i52p3p0gm.apps.googleusercontent.com',
    process.env.GOOGLE_CLIENT_ID
].filter(Boolean);
 
const client = new OAuth2Client();
 
export const autenticarConGoogle = async (req, res) => {
    console.log('➡️ /auth/google llamado. Campos recibidos:', Object.keys(req.body || {}));
 
    try {
        const { idToken } = req.body;
 
        if (!idToken) {
            console.error('❌ Google: falta idToken en el body');
            return res.status(400).json({
                error: 'El idToken de Google es requerido'
            });
        }
 
        // Validar el token con Google
        let ticket;
        try {
            ticket = await client.verifyIdToken({
                idToken,
                audience: GOOGLE_CLIENT_IDS
            });
        } catch (errorToken) {
            console.error('❌ Google: token inválido →', errorToken.message);
            return res.status(401).json({
                error: 'Token de Google inválido o expirado',
                detalle: errorToken.message
            });
        }
 
        const payload = ticket.getPayload();
 
        const {
            sub: googleId,
            email,
            name: nombre,
            picture: avatar
        } = payload;
 
        console.log('✅ Google: token válido para', email);
 
        // Buscar si el usuario ya existe
        const {
            data: usuarioExistente,
            error: errorBusqueda
        } = await obtenerUsuarioPorEmail(email);
 
        if (errorBusqueda && errorBusqueda.code !== 'PGRST116') {
            console.error('❌ Google: error al buscar usuario →', errorBusqueda);
            return res.status(500).json({
                error: 'Error al consultar el usuario',
                detalle: errorBusqueda.message
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
                    console.error('❌ Google: error al actualizar usuario →', errorActualizacion);
                    return res.status(500).json({
                        error: 'No se pudo actualizar el usuario',
                        detalle: errorActualizacion.message
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
                console.error('❌ Google: error al crear usuario →', errorCrear);
                return res.status(500).json({
                    error: 'Error al registrar el usuario con Google',
                    detalle: errorCrear.message
                });
            }
 
            usuarioFinal = nuevoUsuario;
 
            const { error: errorNotificacion } = await crearNotificacion({
                usuario_id: nuevoUsuario.id,
                tipo: 'bienvenida',
                titulo: '¡Bienvenido a Asadero La Ceiba!',
                mensaje: `Hola ${nuevoUsuario.nombre}, tu cuenta se creó correctamente con Google.`
            });
 
            if (errorNotificacion) {
                console.error(
                    'Error al crear la notificación de bienvenida:',
                    errorNotificacion.message
                );
            }
        }
 
        // Crear Access Token y Refresh Token.
        const { token, refreshToken } = await generarTokens(usuarioFinal);
 
        console.log('✅ Google: login correcto para', email);
 
        return res.status(200).json({
            message: usuarioExistente
                ? 'Inicio de sesión exitoso con Google'
                : 'Registro exitoso con Google',
            token,
            refreshToken,
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
        console.error('❌ Error en autenticarConGoogle:', error);
 
        return res.status(500).json({
            error: 'Error interno en el login con Google',
            detalle: error.message
        });
    }
};