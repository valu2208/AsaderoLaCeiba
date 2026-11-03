import { supabase } from '../config/supabase.js';

// Un pedido por id (sin detalles)
export const obtenerPedidoPorIdBD = async (id) => {
  const { data, error } = await supabase
    .from('pedidos')
    .select('*')
    .eq('id', id)
    .maybeSingle();

  return { data, error };
};

// Pedidos en ciertos estados, con el nombre del cliente y los platos.
// Se hacen consultas separadas para no depender de relaciones en Supabase.
export const obtenerPedidosConCliente = async (estados) => {
  const { data: pedidos, error } = await supabase
    .from('pedidos')
    .select('*, detalle_pedido(*)')
    .in('estado', estados)
    .order('id', { ascending: true });

  if (error) return { data: null, error };
  if (!pedidos.length) return { data: [], error: null };

  const usuarioIds = [...new Set(pedidos.map((p) => p.usuario_id))];
  const productoIds = [
    ...new Set(
      pedidos.flatMap((p) => p.detalle_pedido.map((d) => d.producto_id))
    )
  ];

  const [usuarios, productos] = await Promise.all([
    supabase.from('usuarios').select('id, nombre').in('id', usuarioIds),
    supabase.from('productos').select('id, nombre').in('id', productoIds)
  ]);

  const nombreCliente = Object.fromEntries(
    (usuarios.data || []).map((u) => [u.id, u.nombre])
  );
  const nombrePlato = Object.fromEntries(
    (productos.data || []).map((p) => [p.id, p.nombre])
  );

  const data = pedidos.map((p) => ({
    id: p.id,
    estado: p.estado,
    total: p.total,
    notas: p.notas,
    telefono: p.telefono,
    creado_en: p.creado_en ?? null,
    cliente: nombreCliente[p.usuario_id] || 'Cliente',
    items: p.detalle_pedido.map((d) => ({
      nombre: nombrePlato[d.producto_id] || 'Producto',
      cantidad: d.cantidad
    }))
  }));

  return { data, error: null };
};