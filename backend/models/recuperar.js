import { supabase } from '../config/supabase.js';

// Buscar usuario por correo
export const obtenerUsuarioPorEmail = async (email) => {
    const { data, error } = await supabase
        .from('usuarios')
        .select('id, nombre, email')
        .eq('email', email)
        .single();

    return { data, error };
};

// Invalidar códigos anteriores del usuario
export const invalidarCodigosAnteriores = async (usuario_id) => {
    const { data, error } = await supabase
        .from('recovery_codes')
        .update({ usado: true })
        .eq('usuario_id', usuario_id)
        .eq('usado', false);

    return { data, error };
};

// Crear código de recuperación
export const crearCodigoRecuperacion = async ({
    usuario_id,
    codigo,
    expires_at
}) => {
    const { data, error } = await supabase
        .from('recovery_codes')
        .insert({
            usuario_id,
            codigo,
            expires_at,
            usado: false
        })
        .select()
        .single();

    return { data, error };
};

// Buscar código válido
export const obtenerCodigoValido = async (usuario_id, codigo) => {
    const { data, error } = await supabase
        .from('recovery_codes')
        .select('*')
        .eq('usuario_id', usuario_id)
        .eq('codigo', codigo)
        .eq('usado', false)
        .gt('expires_at', new Date().toISOString())
        .order('creado_en', { ascending: false })
        .limit(1)
        .maybeSingle();

    return { data, error };
};

// Actualizar contraseña
export const actualizarPassword = async (usuario_id, password) => {
    const { data, error } = await supabase
        .from('usuarios')
        .update({ password })
        .eq('id', usuario_id)
        .select('id, nombre, email, telefono, rol, creado_en')
        .single();

    return { data, error };
};

// Marcar código como usado
export const marcarCodigoUsado = async (id) => {
    const { data, error } = await supabase
        .from('recovery_codes')
        .update({ usado: true })
        .eq('id', id);

    return { data, error };
};