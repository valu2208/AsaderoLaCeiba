import { supabase } from '../config/supabase.js';

export const obtenerPedidoPagoBD = async (id) => {
  const { data, error } = await supabase
    .from('pedidos')
    .select('id, usuario_id, metodo_pago, estado_pago, comprobante_pago_url, estado, total, numero_mesa')
    .eq('id', id)
    .maybeSingle();

  return { data, error };
};

export const guardarComprobanteBD = async (id, url) => {
  const { data, error } = await supabase
    .from('pedidos')
    .update({
      metodo_pago: 'qr',
      comprobante_pago_url: url,
      estado_pago: 'Pendiente',
      observacion_pago: null
    })
    .eq('id', id)
    .select()
    .maybeSingle();

  return { data, error };
};

export const listarComprobantesBD = async () => {
  const { data: pedidos, error } = await supabase
    .from('pedidos')
    .select('id, usuario_id, total, numero_mesa, estado, estado_pago, comprobante_pago_url, fecha_pedido')
    .eq('estado_pago', 'Pendiente')
    .not('comprobante_pago_url', 'is', null)
    .order('id', { ascending: false });

  if (error) return { error };
  if (!pedidos || pedidos.length === 0) return { data: [] };

  const ids = [...new Set(pedidos.map(p => p.usuario_id))];
  const { data: usuarios } = await supabase
    .from('usuarios').select('id, nombre, telefono').in('id', ids);

  const porId = new Map((usuarios || []).map(u => [u.id, u]));

  return {
    data: pedidos.map(p => ({
      ...p,
      cliente: porId.get(p.usuario_id)?.nombre || 'Cliente',
      telefono: porId.get(p.usuario_id)?.telefono || null
    }))
  };
};

export const actualizarPagoBD = async (id, estado, observacion = null) => {
  const { data, error } = await supabase
    .from('pedidos')
    .update({
      estado_pago: estado,
      observacion_pago: observacion,
      fecha_pago_confirmado: estado === 'Aprobado' ? new Date().toISOString() : null
    })
    .eq('id', id)
    .select()
    .maybeSingle();

  return { data, error };
};