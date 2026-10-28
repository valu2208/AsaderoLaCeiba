
import { supabase } from '../config/supabase.js';

// Crear una notificación para un usuario.
export const crearNotificacion = async ({
    usuario_id,
    pedido_id = null,
    tipo,
    titulo,
    mensaje
}) => {
    const { data, error } = await supabase
        .from('notificaciones')
        .insert({
            usuario_id,
            pedido_id,
            tipo,
            titulo,
            mensaje
        })
        .select()
        .single();

    return { data, error };
};

// Obtener las notificaciones de un usuario, de más recientes a más antiguas.
export const obtenerNotificaciones = async (usuario_id) => {
    const { data, error } = await supabase
        .from('notificaciones')
        .select('*')
        .eq('usuario_id', usuario_id)
        .order('creado_en', { ascending: false });

    return { data, error };
};

// Marcar como leída una notificación perteneciente al usuario autenticado.
export const marcarNotificacionLeida = async (id, usuario_id) => {
    const { data, error } = await supabase
        .from('notificaciones')
        .update({ leida: true })
        .eq('id', id)
        .eq('usuario_id', usuario_id)
        .select()
        .maybeSingle();

    return { data, error };
};

// Consultar cuántas notificaciones tiene sin leer un usuario.
export const contarNotificacionesNoLeidas = async (usuario_id) => {
    const { count, error } = await supabase
        .from('notificaciones')
        .select('*', { count: 'exact', head: true })
        .eq('usuario_id', usuario_id)
        .eq('leida', false);

    return { count, error };
};
