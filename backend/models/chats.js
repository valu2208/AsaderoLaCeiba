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

export const obtenerMensajesPorSesion = async (sesion_id) => {
    const { data, error } = await supabase
        .from('mensajes_chat')
        .select('*')
        .eq('sesion_id', sesion_id)
        .order('created_at', { ascending: true });

    return { data, error };
};