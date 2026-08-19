import { supabase } from '../config/supabase.js';

// Crear un nuevo pedido con sus detalles
export const crearPedidoBD = async (datosPedido, productos) => {
  const { 
    usuario_id, 
    numero_mesa, 
    total, 
    moneda_pago, 
    total_moneda_extranjera, 
    metodo_pago, 
    telefono, 
    notas 
  } = datosPedido;

  // 1. Insertar en la tabla 'pedidos'
  const { data: pedido, error: errorPedido } = await supabase
    .from('pedidos')
    .insert([{ 
      usuario_id, 
      numero_mesa,
      total, 
      moneda_pago: moneda_pago || 'COP',
      total_moneda_extranjera,
      metodo_pago,
      telefono, 
      notas,
      estado: 'Pendiente'
    }])
    .select();

  if (errorPedido) return { error: errorPedido };

  const pedido_id = pedido[0].id;

  // 2. Mapear los productos para insertarlos en 'detalle_pedido'
  const detalles = productos.map(item => ({
    pedido_id,
    producto_id: item.producto_id,
    cantidad: item.cantidad,
    precio_unitario: item.precio_unitario,
    subtotal: item.cantidad * item.precio_unitario
  }));

  const { error: errorDetalle } = await supabase
    .from('detalle_pedido')
    .insert(detalles);

  if (errorDetalle) return { error: errorDetalle };

  return { data: pedido[0] };
};

// Obtener todos los pedidos
export const obtenerTodosPedidosBD = async () => {
  const { data, error } = await supabase
    .from('pedidos')
    .select('*, detalle_pedido(*)');

  return { data, error };
};

// Obtener historial de pedidos de un usuario específico
export const obtenerPedidosPorUsuarioBD = async (usuario_id) => {
  const { data, error } = await supabase
    .from('pedidos')
    .select('*, detalle_pedido(*)')
    .eq('usuario_id', usuario_id);

  return { data, error };
};

// Actualizar el estado del pedido
export const cambiarEstadoPedidoBD = async (pedido_id, nuevoEstado) => {
  const { data, error } = await supabase
    .from('pedidos')
    .update({ estado: nuevoEstado, actualizado_es: new Date() })
    .eq('id', pedido_id)
    .select();

  return { data, error };
};