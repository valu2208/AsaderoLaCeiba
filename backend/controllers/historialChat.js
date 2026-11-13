
import {
    obtenerConversacionesPorUsuario,
    obtenerMensajesPorSesion,
    eliminarConversacion
} from '../models/chats.js';

// Listar las conversaciones del usuario autenticado.
export const listarHistorialChat = async (req, res) => {
    try {
        const usuario_id = req.usuario.id;

        const { data, error } =
            await obtenerConversacionesPorUsuario(usuario_id);

        if (error) {
            console.error('Error al consultar historial:', error);
            return res.status(500).json({
                error: 'No se pudo cargar el historial'
            });
        }

        const conversaciones = new Map();

        for (const mensaje of data || []) {
            const id = mensaje.sesion_id;

            if (!conversaciones.has(id)) {
                conversaciones.set(id, {
                    sesion_id: id,
                    titulo: 'Conversación con Asadero La Ceiba',
                    ultimo_mensaje: mensaje.mensaje,
                    fecha: mensaje.created_at
                });
            }

            const conversacion = conversaciones.get(id);

            if (
                mensaje.emisor === 'usuario' &&
                conversacion.titulo === 'Conversación con Asadero La Ceiba'
            ) {
                conversacion.titulo = mensaje.mensaje;
            }

            conversacion.ultimo_mensaje = mensaje.mensaje;
            conversacion.fecha = mensaje.created_at;
        }

        const historial = Array.from(conversaciones.values())
            .sort((a, b) => new Date(b.fecha) - new Date(a.fecha));

        return res.status(200).json({
            conversaciones: historial
        });
    } catch (error) {
        console.error('Error en listarHistorialChat:', error);
        return res.status(500).json({
            error: 'Error interno al consultar el historial'
        });
    }
};

// Consultar los mensajes de una conversación específica.
export const obtenerHistorialChat = async (req, res) => {
    try {
        const usuario_id = req.usuario.id;
        const { sesionId } = req.params;

        const { data, error } = await obtenerMensajesPorSesion(
            sesionId,
            usuario_id
        );

        if (error) {
            console.error('Error al consultar conversación:', error);
            return res.status(500).json({
                error: 'No se pudo cargar la conversación'
            });
        }

        if (!data || data.length === 0) {
            return res.status(404).json({
                error: 'No se encontró la conversación'
            });
        }

        return res.status(200).json({
            sesion_id: sesionId,
            mensajes: data
        });
    } catch (error) {
        console.error('Error en obtenerHistorialChat:', error);
        return res.status(500).json({
            error: 'Error interno al consultar la conversación'
        });
    }
};

// Eliminar una conversación del usuario autenticado.
export const eliminarHistorialChat = async (req, res) => {
    try {
        const usuario_id = req.usuario.id;
        const { sesionId } = req.params;

        if (!sesionId) {
            return res.status(400).json({
                error: 'El identificador de la conversación es requerido'
            });
        }

        const { data, error } = await eliminarConversacion(
            sesionId,
            usuario_id
        );

        if (error) {
            console.error('Error al eliminar conversación:', error);
            return res.status(500).json({
                error: 'No se pudo eliminar la conversación'
            });
        }

        if (!data || data.length === 0) {
            return res.status(404).json({
                error: 'No se encontró la conversación'
            });
        }

        return res.status(200).json({
            mensaje: 'Conversación eliminada correctamente'
        });
    } catch (error) {
        console.error('Error en eliminarHistorialChat:', error);
        return res.status(500).json({
            error: 'Error interno al eliminar la conversación'
        });
    }
};
