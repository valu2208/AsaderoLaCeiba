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

// Un pedido por su id (sin detalles)
export const obtenerPedidoPorIdBD = async (pedido_id) => {
  const { data, error } = await supabase
    .from('pedidos')
    .select('*')
    .eq('id', pedido_id)
    .maybeSingle();

  return { data, error };
};

// Pedidos en ciertos estados, del más antiguo al más nuevo, con lo que necesitan
// el mesero y la cocina: nombre del cliente y nombre de cada plato.
export const obtenerPedidosPorEstadosBD = async (estados) => {
  const { data: pedidos, error } = await supabase
    .from('pedidos')
    .select('*, detalle_pedido(*)')
    .in('estado', estados)
    .order('fecha_pedido', { ascending: true });

  if (error) return { error };
  if (!pedidos || pedidos.length === 0) return { data: [] };

  const usuarioIds = [...new Set(pedidos.map((p) => p.usuario_id))];
  const productoIds = [
    ...new Set(
      pedidos.flatMap((p) => (p.detalle_pedido || []).map((d) => d.producto_id))
    )
  ];

  const [usuarios, productos] = await Promise.all([
    supabase.from('usuarios').select('id, nombre').in('id', usuarioIds),
    supabase.from('productos').select('id, nombre').in('id', productoIds)
  ]);

  const nombreUsuario = new Map((usuarios.data || []).map((u) => [u.id, u.nombre]));
  const nombreProducto = new Map((productos.data || []).map((p) => [p.id, p.nombre]));

  const completos = pedidos.map((pedido) => ({
    id: pedido.id,
    estado: pedido.estado,
    fecha_pedido: pedido.fecha_pedido,
    total: pedido.total,
    notas: pedido.notas,
    cliente: nombreUsuario.get(pedido.usuario_id) || 'Cliente',
    items: (pedido.detalle_pedido || []).map((detalle) => ({
      nombre: nombreProducto.get(detalle.producto_id) || 'Plato',
      cantidad: detalle.cantidad
    }))
  }));

  return { data: completos };
};