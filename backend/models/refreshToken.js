
import { supabase } from '../config/supabase.js';

// Registrar una nueva sesión.
export const crearRefreshTokenBD = async (
    usuarioId,
    tokenHash,
    expiresAt
) => {
    const { data, error } = await supabase
        .from('refresh_tokens')
        .insert({
            usuario_id: usuarioId,
            token_hash: tokenHash,
            expires_at: expiresAt
        })
        .select()
        .single();

    return { data, error };
};

// Buscar una sesión mediante el hash del token.
export const obtenerRefreshTokenBD = async (tokenHash) => {
    const { data, error } = await supabase
        .from('refresh_tokens')
        .select('*')
        .eq('token_hash', tokenHash)
        .maybeSingle();

    return { data, error };
};

// Revocar una sesión específica.
export const revocarRefreshTokenBD = async (id) => {
    const { data, error } = await supabase
        .from('refresh_tokens')
        .update({
            revoked_at: new Date().toISOString()
        })
        .eq('id', id)
        .is('revoked_at', null)
        .select()
        .maybeSingle();

    return { data, error };
};
