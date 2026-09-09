import { supabase } from '../config/supabase.js';

// Crear usuario
export const crearUsuario = async (usuarioData) => {
    const { data, error } = await supabase
        .from('usuarios')
        .insert(usuarioData)
        .select()
        .single();

    return { data, error };
};

// Obtener todos los usuarios
export const obtenerTodosUsuarios = async () => {
    const { data, error } = await supabase
        .from('usuarios')
        .select('id, nombre, email, telefono, rol, creado_en');

    return { data, error };
};

// Obtener usuario por ID
export const obtenerUsuarioPorId = async (id) => {
    const { data, error } = await supabase
        .from('usuarios')
        .select('id, nombre, email, telefono, rol, creado_en')
        .eq('id', id)
        .single();

    return { data, error };
};

// Obtener usuario por email
export const obtenerUsuarioPorEmail = async (email) => {
    const { data, error } = await supabase
        .from('usuarios')
        .select('*')
        .eq('email', email)
        .single();

    return { data, error };
};

// Actualizar usuario
export const actualizarUsuario = async (id, usuarioData) => {
    const { data, error } = await supabase
        .from('usuarios')
        .update(usuarioData)
        .eq('id', id)
        .select('id, nombre, email, telefono, rol, creado_en')
        .single();

    return { data, error };
};

// Eliminar usuario
export const eliminarUsuario = async (id) => {
    const { data, error } = await supabase
        .from('usuarios')
        .delete()
        .eq('id', id)
        .select()
        .single();

    return { data, error };
};

// Crear código de recuperación
export const crearCodigoRecuperacion = async (codigoData) => {
    const { data, error } = await supabase
        .from('recovery_codes')
        .insert(codigoData)
        .select()
        .single();

    return { data, error };
};

// Obtener código de recuperación válido
export const obtenerCodigoRecuperacion = async (usuarioId, codigo) => {
    const { data, error } = await supabase
        .from('recovery_codes')
        .select('*')
        .eq('usuario_id', usuarioId)
        .eq('codigo', codigo)
        .eq('usado', false)
        .gt('expires_at', new Date().toISOString())
        .order('id', { ascending: false })
        .limit(1)
        .maybeSingle();

    return { data, error };
};

// Marcar código de recuperación como usado
export const marcarCodigoUsado = async (id) => {
    const { data, error } = await supabase
        .from('recovery_codes')
        .update({ usado: true })
        .eq('id', id)
        .select()
        .single();

    return { data, error };
};

// Obtener usuario con código de verificación válido
export const obtenerUsuarioPorCodigoVerificacion = async (
    email,
    codigo
) => {
    const { data, error } = await supabase
        .from('usuarios')
        .select('*')
        .eq('email', email)
        .eq('codigoVerificacion', codigo)
        .eq('isVerified', false)
        .gt(
            'codigoVerificacionExpiracion',
            new Date().toISOString()
        )
        .maybeSingle();

    return { data, error };
};
// Marcar usuario como verificado
export const verificarUsuario = async (id) => {
    const { data, error } = await supabase
        .from('usuarios')
        .update({
            isVerified: true,
            codigoVerificacion: null,
            codigoVerificacionExpiracion: null
        })
        .eq('id', id)
        .select('id, nombre, email, telefono, rol, isVerified, creado_en')
        .single();

    return { data, error };
};

// Actualizar código de verificación
export const actualizarCodigoVerificacion = async (
    email,
    codigoVerificacion,
    codigoVerificacionExpiracion
) => {
    const { data, error } = await supabase
        .from('usuarios')
        .update({
            codigoVerificacion,
            codigoVerificacionExpiracion
        })
        .eq('email', email)
        .eq('isVerified', false)
        .select('id, nombre, email, isVerified, codigoVerificacion, codigoVerificacionExpiracion')
        .single();

    return { data, error };
};
// Crear usuario autenticado con Google
export const crearUsuarioGoogle = async ({
    nombre,
    email,
    googleId,
    avatar = null,
    rol = 'usuario'
}) => {
    const { data, error } = await supabase
        .from('usuarios')
        .insert({
            nombre,
            email,
            telefono: '', 
            password: null,
            rol,
            isVerified: true,
            googleId,
            avatar,
            codigoVerificacion: null,
            codigoVerificacionExpiracion: null
        })
        .select()
        .single();

    return { data, error };
};