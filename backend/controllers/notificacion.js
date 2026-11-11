
import {
    obtenerNotificaciones,
    marcarNotificacionLeida,
    contarNotificacionesNoLeidas,
    eliminarNotificaciones
} from '../models/notificacion.js';

// Obtener las notificaciones del usuario autenticado.
export const listarNotificaciones = async (req, res) => {
    try {
        const usuario_id = req.usuario.id;

        const { data, error } = await obtenerNotificaciones(usuario_id);

        if (error) {
            return res.status(500).json({
                error: 'No se pudieron obtener las notificaciones'
            });
        }

        return res.status(200).json(data);
    } catch (error) {
        return res.status(500).json({
            error: 'Error al consultar las notificaciones'
        });
    }
};

// Marcar como leída una notificación.
export const leerNotificacion = async (req, res) => {
    try {
        const usuario_id = req.usuario.id;
        const { id } = req.params;

        const { data, error } = await marcarNotificacionLeida(
            id,
            usuario_id
        );

        if (error) {
            return res.status(500).json({
                error: 'No se pudo actualizar la notificación'
            });
        }

        if (!data) {
            return res.status(404).json({
                error: 'Notificación no encontrada'
            });
        }

        return res.status(200).json({
            message: 'Notificación marcada como leída',
            notificacion: data
        });
    } catch (error) {
        return res.status(500).json({
            error: 'Error al actualizar la notificación'
        });
    }
};

// Obtener la cantidad de notificaciones no leídas.
export const contarNoLeidas = async (req, res) => {
    try {
        const usuario_id = req.usuario.id;

        const { count, error } = await contarNotificacionesNoLeidas(
            usuario_id
        );

        if (error) {
            return res.status(500).json({
                error: 'No se pudo consultar el contador'
            });
        }

        return res.status(200).json({
            no_leidas: count ?? 0
        });
    } catch (error) {
        return res.status(500).json({
            error: 'Error al consultar el contador'
        });
    }
};

export const borrarNotificaciones = async (req, res) => {
    try {
        const usuario_id = req.usuario.id;

        const { data, error } = await eliminarNotificaciones(usuario_id);

        if (error) {
            console.error('ERROR AL ELIMINIAR NOTIFICACIONES:', error);
            return res.status(500).json({
                error: 'No se pudieron eliminar las notificaciones'
            });
        }

        return res.status(200).json({
            message: 'Notificaciones eliminadas correctamente',
            eliminadas: data?.length ?? 0
        });
    } catch (error) {
        return res.status(500).json({
            error: 'Error al eliminar las notificaciones'
        });
    }
};
