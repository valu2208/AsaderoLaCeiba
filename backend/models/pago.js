import { supabase } from '../config/supabase.js';

// Obtener los datos de pago de un pedido.
export const obtenerPedidoPagoBD = async (id) => {
    const { data, error } = await supabase
        .from('pedidos')
        .select('id, usuario_id, metodo_pago, estado_pago, comprobante_pago_url, estado')
        .eq('id', id)
        .single();

    if (error) throw error;

    return data;
};

// Guardar el comprobante enviado por el cliente.
export const guardarComprobanteBD = async (id, url) => {
    const { data, error } = await supabase
        .from('pedidos')
        .update({
            comprobante_pago_url: url,
            estado_pago: 'Pendiente',
            observacion_pago: null
        })
        .eq('id', id)
        .select()
        .single();

    if (error) throw error;

    return data;
};

// Listar comprobantes pendientes para el administrador.
export const listarComprobantesBD = async () => {
    const { data, error } = await supabase
        .from('pedidos')
        .select(`
            id,
            usuario_id,
            total,
            metodo_pago,
            estado,
            estado_pago,
            comprobante_pago_url,
            fecha,
            usuarios (
                nombre,
                telefono
            )
        `)
        .in('metodo_pago', ['qr', 'nequi'])
        .eq('estado_pago', 'Pendiente')
        .not('comprobante_pago_url', 'is', null)
        .order('id', { ascending: false });

    if (error) throw error;

    return data;
};

// Aprobar o rechazar un pago.
export const actualizarPagoBD = async (id, estado, observacion = null) => {
    const { data, error } = await supabase
        .from('pedidos')
        .update({
            estado_pago: estado,
            observacion_pago: observacion,
            fecha_pago_confirmado:
                estado === 'Aprobado' ? new Date().toISOString() : null
        })
        .eq('id', id)
        .select()
        .single();

    if (error) throw error;

    return data;
};