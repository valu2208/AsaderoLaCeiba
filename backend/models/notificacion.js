import { supabase } from '../config/supabase.js';
import { enviarPush } from '../utils/push.js';

// Crear una notificación para un usuario.
export const crearNotificacion = async ({
    usuario_id,
    pedido_id = null,
    tipo,
    titulo,
    mensaje
}) => {
    const { data, error } = await supabase
        .from('notificaciones')
        .insert({
            usuario_id,
            pedido_id,
            tipo,
            titulo,
            mensaje
        })
        .select()
        .single();

    // Push en segundo plano: no se espera y nunca rompe el flujo
    if (!error) {
        enviarPush([usuario_id], { tipo, titulo, mensaje, pedido_id });
    }

    return { data, error };
};

// Obtener las notificaciones de un usuario.
export const obtenerNotificaciones = async (usuario_id) => {
    const { data, error } = await supabase
        .from('notificaciones')
        .select('*')
        .eq('usuario_id', usuario_id)
        .order('creado_en', { ascending: false });

    return { data, error };
};

// Marcar como leída una notificación.
export const marcarNotificacionLeida = async (id, usuario_id) => {
    const { data, error } = await supabase
        .from('notificaciones')
        .update({ leida: true })
        .eq('id', id)
        .eq('usuario_id', usuario_id)
        .select()
        .maybeSingle();

    return { data, error };
};

// Consultar cuántas notificaciones tiene sin leer un usuario.
export const contarNotificacionesNoLeidas = async (usuario_id) => {
    const { count, error } = await supabase
        .from('notificaciones')
        .select('*', { count: 'exact', head: true })
        .eq('usuario_id', usuario_id)
        .eq('leida', false);

    return { count, error };
};

// Eliminar las notificaciones ya leídas de un usuario (las no leídas se quedan).
export const eliminarNotificaciones = async (usuario_id) => {
    const { data, error } = await supabase
        .from('notificaciones')
        .delete()
        .eq('usuario_id', usuario_id)
        .eq('leida', true)
        .select('id');

    return { data, error };
};

// Pedido al que apunta una notificación, con sus platos (foto, precio, cantidad).
// Solo lo devuelve si la notificación es del usuario que pregunta.
export const obtenerPedidoDeNotificacion = async (id, usuario_id) => {
    const { data: notificacion, error } = await supabase
        .from('notificaciones')
        .select('pedido_id')
        .eq('id', id)
        .eq('usuario_id', usuario_id)
        .maybeSingle();

    if (error) return { error };
    if (!notificacion) return { noEncontrada: true };
    if (!notificacion.pedido_id) return { data: null };

    const { data: pedido, error: errorPedido } = await supabase
        .from('pedidos')
        .select('id, estado, total, numero_mesa, notas, detalle_pedido(*)')
        .eq('id', notificacion.pedido_id)
        .maybeSingle();

    if (errorPedido) return { error: errorPedido };
    if (!pedido) return { data: null };

    const ids = (pedido.detalle_pedido || []).map((d) => d.producto_id);
    const { data: productos } = await supabase
        .from('productos')
        .select('id, nombre, imagen_url')
        .in('id', ids);

    const porId = new Map((productos || []).map((p) => [p.id, p]));

    return {
        data: {
            id: pedido.id,
            estado: pedido.estado,
            total: pedido.total,
            mesa: pedido.numero_mesa,
            notas: pedido.notas,
            items: (pedido.detalle_pedido || []).map((d) => ({
                nombre: porId.get(d.producto_id)?.nombre || 'Plato',
                imagen_url: porId.get(d.producto_id)?.imagen_url || null,
                precio: d.precio_unitario,
                cantidad: d.cantidad
            }))
        }
    };
};

// Crear el mismo aviso para todos los usuarios de un rol.
export const avisarRol = async (
    rol,
    { pedido_id = null, tipo, titulo, mensaje }
) => {
    const { data: usuarios, error } = await supabase
        .from('usuarios')
        .select('id')
        .ilike('rol', rol);

    if (error) return { error };
    if (!usuarios || usuarios.length === 0) return { data: [] };

    const filas = usuarios.map((usuario) => ({
        usuario_id: usuario.id,
        pedido_id,
        tipo,
        titulo,
        mensaje
    }));

    const { data, error: errorInsert } = await supabase
        .from('notificaciones')
        .insert(filas)
        .select();

    // Push en segundo plano para todos los usuarios de ese rol
    if (!errorInsert) {
        enviarPush(
            usuarios.map((usuario) => usuario.id),
            { tipo, titulo, mensaje, pedido_id }
        );
    }

    return { data, error: errorInsert };
};