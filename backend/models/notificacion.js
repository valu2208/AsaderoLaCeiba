
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

// Obtener las notificaciones de un usuario.
export const obtenerNotificaciones = async (usuario_id) => {
    const { data, error } = await supabase
        .from('notificaciones')
        .select('*')
        .eq('usuario_id', usuario_id)
        .order('creado_en', { ascending: false });

    return { data, error };
};

// Marcar como leída una notificación.
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

// Eliminar todas las notificaciones de un usuario.
export const eliminarNotificaciones = async (usuario_id) => {
    const { data, error } = await supabase
        .from('notificaciones')
        .delete()
        .eq('usuario_id', usuario_id)
        .select('id');

    return { data, error };
};

// Crear el mismo aviso para todos los usuarios de un rol.
export const avisarRol = async (
    rol,
    { pedido_id = null, tipo, titulo, mensaje }
) => {
    const { data: usuarios, error } = await supabase
        .from('usuarios')
        .select('id')
        .ilike('rol', rol);

    if (error) return { error };
    if (!usuarios || usuarios.length === 0) return { data: [] };

    const filas = usuarios.map((usuario) => ({
        usuario_id: usuario.id,
        pedido_id,
        tipo,
        titulo,
        mensaje
    }));

    const { data, error: errorInsert } = await supabase
        .from('notificaciones')
        .insert(filas)
        .select();

    return { data, error: errorInsert };
};
