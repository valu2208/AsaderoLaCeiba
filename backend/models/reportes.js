import { supabase } from '../config/supabase.js';

// Pedidos entregados dentro de un rango de fechas (UTC), con sus platos
export const obtenerEntregadosBD = async (desde, hasta) => {
  const { data, error } = await supabase
    .from('pedidos')
    .select('id, total, fecha_pedido, detalle_pedido(producto_id, cantidad, precio_unitario)')
    .eq('estado', 'Entregado')
    .gte('fecha_pedido', desde)
    .lt('fecha_pedido', hasta);

  return { data, error };
};

export const obtenerNombresProductosBD = async (ids) => {
  const { data, error } = await supabase
    .from('productos')
    .select('id, nombre')
    .in('id', ids);

  return { data, error };
};