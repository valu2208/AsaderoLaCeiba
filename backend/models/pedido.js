
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

  const detalles = productos.map(item => ({
    pedido_id,
    producto_id: item.producto_id,
    cantidad: item.cantidad,
    precio_unitario: item.precio_unitario
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

// Obtener historial visible de un usuario
export const obtenerPedidosPorUsuarioBD = async (usuario_id) => {
  const { data: pedidos, error } = await supabase
    .from('pedidos')
    .select('*, detalle_pedido(*)')
    .eq('usuario_id', usuario_id)
    .eq('visible_historial', true)
    .order('fecha_pedido', { ascending: false });

  if (error) return { error };
  if (!pedidos || pedidos.length === 0) return { data: [] };

  const productoIds = [
    ...new Set(
      pedidos.flatMap(p =>
        (p.detalle_pedido || []).map(d => d.producto_id)
      )
    )
  ];

  if (productoIds.length === 0) return { data: pedidos };

  const { data: productos, error: errorProductos } = await supabase
    .from('productos')
    .select('id, nombre')
    .in('id', productoIds);

  if (errorProductos) return { error: errorProductos };

  const nombres = new Map(
    (productos || []).map(p => [p.id, p.nombre])
  );

  const pedidosCompletos = pedidos.map(pedido => ({
    ...pedido,
    detalle_pedido: (pedido.detalle_pedido || []).map(detalle => ({
      ...detalle,
      nombre: nombres.get(detalle.producto_id) || 'Producto'
    }))
  }));

  return { data: pedidosCompletos };
};

// Ocultar el historial del usuario sin eliminar sus pedidos
export const ocultarHistorialPedidosBD = async (usuario_id) => {
  const { data, error } = await supabase
    .from('pedidos')
    .update({ visible_historial: false })
    .eq('usuario_id', usuario_id)
    .eq('visible_historial', true)
    .select('id');

  return { data, error };
};

// Cambiar el estado del pedido
export const cambiarEstadoPedidoBD = async (
  pedido_id,
  nuevoEstado,
  extras = {}
) => {
  const { data, error } = await supabase
    .from('pedidos')
    .update({
      estado: nuevoEstado,
      actualizado_es: new Date(),
      ...extras
    })
    .eq('id', pedido_id)
    .select();

  return { data, error };
};

// Obtener un pedido por su id
export const obtenerPedidoPorIdBD = async (pedido_id) => {
  const { data, error } = await supabase
    .from('pedidos')
    .select('*')
    .eq('id', pedido_id)
    .maybeSingle();

  return { data, error };
};

// Obtener pedidos por estados para meseros y cocina
export const obtenerPedidosPorEstadosBD = async (estados) => {
  const { data: pedidos, error } = await supabase
    .from('pedidos')
    .select('*, detalle_pedido(*)')
    .in('estado', estados)
    .order('fecha_pedido', { ascending: true });

  if (error) return { error };
  if (!pedidos || pedidos.length === 0) return { data: [] };

  const usuarioIds = [...new Set(pedidos.map(p => p.usuario_id))];

  const productoIds = [
    ...new Set(
      pedidos.flatMap(p =>
        (p.detalle_pedido || []).map(d => d.producto_id)
      )
    )
  ];

  const [usuarios, productos] = await Promise.all([
    supabase.from('usuarios').select('id, nombre').in('id', usuarioIds),
    supabase.from('productos').select('id, nombre').in('id', productoIds)
  ]);

  const nombreUsuario = new Map(
    (usuarios.data || []).map(u => [u.id, u.nombre])
  );

  const nombreProducto = new Map(
    (productos.data || []).map(p => [p.id, p.nombre])
  );

  const completos = pedidos.map(pedido => ({
    id: pedido.id,
    estado: pedido.estado,
    fecha_pedido: pedido.fecha_pedido,
    total: pedido.total,
    notas: pedido.notas,
    mesa: pedido.numero_mesa,
    cliente: nombreUsuario.get(pedido.usuario_id) || 'Cliente',
    items: (pedido.detalle_pedido || []).map(detalle => ({
      nombre: nombreProducto.get(detalle.producto_id) || 'Plato',
      cantidad: detalle.cantidad
    }))
  }));

  return { data: completos };
};

// Cancelar pedido si pertenece al usuario y sigue pendiente
export const cancelarPedidoBD = async (pedido_id, usuario_id) => {
  const { data, error } = await supabase
    .from('pedidos')
    .update({
      estado: 'Cancelado',
      actualizado_es: new Date()
    })
    .eq('id', pedido_id)
    .eq('usuario_id', usuario_id)
    .eq('estado', 'Pendiente')
    .select()
    .maybeSingle();

  return { data, error };
};
