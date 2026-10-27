import { supabase } from '../config/supabase.js';

export const obtenerTodos = async () => {
    const { data, error } = await supabase
        .from('productos')
        .select('*')
        .eq('activo', true);

    return { data, error };
};

// Lista para el admin (activos e inactivos). Filtros opcionales:
//   masPedido: true -> solo "lo más pedido" | false -> solo los del menú
//   categoria: 'desayuno' | 'almuerzo' | 'fin_de_semana' | 'gaseosas'
//   dia: 'lunes' ... 'domingo' (platos que se sirven ese día)
export const obtenerTodosAdmin = async ({ masPedido, categoria, dia } = {}) => {
    let consulta = supabase.from('productos').select('*');

    if (masPedido !== undefined) consulta = consulta.eq('mas_pedido', masPedido);
    if (categoria) consulta = consulta.eq('categoria', categoria);
    if (dia) consulta = consulta.contains('dias', [dia]);

    const { data, error } = await consulta.order('nombre');

    return { data, error };
};

// Lo que ve el cliente en el Home: activos marcados como más pedidos
export const obtenerMasPedidos = async () => {
    const { data, error } = await supabase
        .from('productos')
        .select('*')
        .eq('activo', true)
        .eq('mas_pedido', true);

    return { data, error };
};

export const obtenerPorId = async (id) => {
    const { data, error } = await supabase
        .from('productos')
        .select('*')
        .eq('id', id)
        .single();

    return { data, error };
};

// Platos del MENÚ activos de una categoría (los "más pedidos" no entran).
// Si llega 'dia' solo trae los de ese día
export const obtenerPorCategoria = async (categoria, dia) => {
    let consulta = supabase
        .from('productos')
        .select('*')
        .eq('categoria', categoria)
        .eq('mas_pedido', false)
        .eq('activo', true);

    if (dia) consulta = consulta.contains('dias', [dia]);

    const { data, error } = await consulta;

    return { data, error };
};

export const crearProducto = async (productoData) => {
    const { data, error } = await supabase
        .from('productos')
        .insert(productoData)
        .select();

    return { data, error };
};

export const actualizarProducto = async (id, productoData) => {
    const { data, error } = await supabase
        .from('productos')
        .update(productoData)
        .eq('id', id)
        .select();

    return { data, error };
};

// Desactivar producto: se conserva en la base de datos.
export const eliminarProducto = async (id) => {
    const { data, error } = await supabase
        .from('productos')
        .update({ activo: false })
        .eq('id', id)
        .select();

    return { data, error };
};

export const activarProducto = async (id) => {
    const { data, error } = await supabase
        .from('productos')
        .update({ activo: true })
        .eq('id', id)
        .select();

    return { data, error };
};

// Eliminar definitivamente: falla si existen detalles de pedidos.
export const eliminarProductoDefinitivamente = async (id) => {
    const { data, error } = await supabase
        .from('productos')
        .delete()
        .eq('id', id)
        .select();

    return { data, error };
};