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