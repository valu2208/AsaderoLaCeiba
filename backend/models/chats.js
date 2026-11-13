
import { supabase } from '../config/supabase.js';

export const guardarMensaje = async ({
    sesion_id,
    usuario_id,
    emisor,
    mensaje
}) => {
    const { data, error } = await supabase
        .from('mensajes_chat')
        .insert({
            sesion_id,
            usuario_id,
            emisor,
            mensaje
        })
        .select()
        .single();

    return { data, error };
};

// Obtener mensajes de una conversación perteneciente al usuario.
export const obtenerMensajesPorSesion = async (sesion_id, usuario_id) => {
    const { data, error } = await supabase
        .from('mensajes_chat')
        .select('*')
        .eq('sesion_id', sesion_id)
        .eq('usuario_id', usuario_id)
        .order('created_at', { ascending: true });

    return { data, error };
};

// Obtener los mensajes del usuario para construir su lista de conversaciones.
export const obtenerConversacionesPorUsuario = async (usuario_id) => {
    const { data, error } = await supabase
        .from('mensajes_chat')
        .select('sesion_id, emisor, mensaje, created_at')
        .eq('usuario_id', usuario_id)
        .order('created_at', { ascending: true })
        .limit(1000);

    return { data, error };
};

// Eliminar todos los mensajes de una conversación perteneciente al usuario.
export const eliminarConversacion = async (sesion_id, usuario_id) => {
    const { data, error } = await supabase
        .from('mensajes_chat')
        .delete()
        .eq('sesion_id', sesion_id)
        .eq('usuario_id', usuario_id)
        .select('id');

    return { data, error };
};
