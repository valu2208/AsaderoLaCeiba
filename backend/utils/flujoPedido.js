import { obtenerPedidoPorIdBD, cambiarEstadoPedidoBD } from '../models/pedido.js';
import { crearNotificacion, avisarRol } from '../models/notificacion.js';

// Recorrido de un pedido:
// Pendiente -> En cocina -> En preparación -> Listo -> Entregado
// Cada rol solo puede dar ciertos pasos: { estado nuevo: [estados desde los que se puede llegar] }
export const PASOS_MESERO = {
    'En cocina': ['Pendiente'],
    'Entregado': ['Listo']
};

export const PASOS_COCINA = {
    'En preparación': ['En cocina'],
    'Listo': ['En cocina', 'En preparación']
};

// Mensaje que ve el cliente en sus notificaciones
const MENSAJES_CLIENTE = {
    'En cocina': 'Tu pedido fue enviado a la cocina.',
    'En preparación': 'La cocina está preparando tu pedido.',
    'Listo': 'Tu pedido está listo.',
    'Entregado': 'Tu pedido ha sido entregado.'
};

const registrarError = (donde, resultado) => {
    if (resultado?.error) {
        console.error(`Error al notificar (${donde}):`, resultado.error.message);
    }
};

// Cambia el estado si el paso está permitido para ese rol y avisa a quien corresponde.
// "extras" guarda otros datos a la vez, por ejemplo { numero_mesa: 4 }.
// Devuelve { pedido } o { codigo, error }.
export const avanzarPedido = async (id, nuevoEstado, pasosPermitidos, extras = {}) => {
    const desde = pasosPermitidos[nuevoEstado];

    if (!desde) {
        return { codigo: 400, error: 'Estado no permitido para tu rol' };
    }

    const { data: pedido, error } = await obtenerPedidoPorIdBD(id);

    if (error) return { codigo: 500, error: error.message };
    if (!pedido) return { codigo: 404, error: 'Pedido no encontrado' };

    if (!desde.includes(pedido.estado)) {
        return {
            codigo: 400,
            error: `El pedido está "${pedido.estado}" y no puede pasar a "${nuevoEstado}"`
        };
    }

    const { data, error: errorEstado } = await cambiarEstadoPedidoBD(id, nuevoEstado, extras);
    const actualizado = data?.[0];

    if (errorEstado || !actualizado) {
        return { codigo: 500, error: errorEstado?.message || 'No se pudo actualizar el pedido' };
    }

    // Aviso al cliente
    registrarError('cliente', await crearNotificacion({
        usuario_id: actualizado.usuario_id,
        pedido_id: actualizado.id,
        tipo: 'estado_pedido',
        titulo: `Pedido #${actualizado.id}: ${nuevoEstado}`,
        mensaje: MENSAJES_CLIENTE[nuevoEstado]
    }));

    // Avisos al personal
    if (nuevoEstado === 'En cocina') {
        const mesa = actualizado.numero_mesa ? ` (mesa ${actualizado.numero_mesa})` : '';
        registrarError('cocineros', await avisarRol('cocinero', {
            pedido_id: actualizado.id,
            tipo: 'pedido',
            titulo: `Pedido #${actualizado.id} para preparar`,
            mensaje: `El mesero envió un pedido a la cocina${mesa}.`
        }));
    }

    if (nuevoEstado === 'Listo') {
        const mesa = actualizado.numero_mesa ? ` de la mesa ${actualizado.numero_mesa}` : '';
        registrarError('meseros', await avisarRol('mesero', {
            pedido_id: actualizado.id,
            tipo: 'estado_pedido',
            titulo: `Pedido #${actualizado.id} listo`,
            mensaje: `Pasa por el plato${mesa} y llévalo al cliente.`
        }));
    }

    return { pedido: actualizado };
};