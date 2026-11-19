import { supabase } from '../config/supabase.js';

// Guarda el token de un celular. Si el token ya existía, lo pasa al usuario actual.
export const guardarTokenBD = async (usuario_id, token, plataforma = 'android') => {
    const { error } = await supabase
        .from('dispositivos')
        .upsert(
            { usuario_id, token, plataforma, actualizado_en: new Date().toISOString() },
            { onConflict: 'token' }
        );
    return { error };
};

export const borrarTokenBD = async (usuario_id, token) => {
    const { error } = await supabase
        .from('dispositivos')
        .delete()
        .eq('usuario_id', usuario_id)
        .eq('token', token);
    return { error };
};

export const tokensDeUsuarios = async (ids) => {
    const { data, error } = await supabase
        .from('dispositivos')
        .select('token')
        .in('usuario_id', ids);
    return { data, error };
};

export const borrarTokensInvalidos = async (tokens) => {
    if (tokens.length === 0) return;
    await supabase.from('dispositivos').delete().in('token', tokens);
};