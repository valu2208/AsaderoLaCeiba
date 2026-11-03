import { cambiarEstadoPedidoBD } from '../models/pedido.js';
import { obtenerPedidoPorIdBD } from '../models/pedidoPersonal.js';
import { crearNotificacion } from '../models/notificacion.js';

const MENSAJES = {
  'En cocina': 'Tu pedido fue enviado a la cocina.',
  'En preparación': 'La cocina está preparando tu pedido.',
  'Listo': 'Tu pedido está listo.',
  'Entregado': 'Tu pedido ha sido entregado.'
};

// Cambia el estado solo si el pedido está en uno de los estados previos
// permitidos, y le avisa al cliente. Devuelve { pedido } o { status, error }.
export const cambiarEstadoConAviso = async (id, nuevo, estadosPrevios) => {
  const { data: actual, error: errorConsulta } = await obtenerPedidoPorIdBD(id);

  if (errorConsulta) return { status: 500, error: errorConsulta.message };
  if (!actual) return { status: 404, error: 'Pedido no encontrado' };

  if (!estadosPrevios.includes(actual.estado)) {
    return {
      status: 409,
      error: `El pedido está "${actual.estado}" y no puede pasar a "${nuevo}"`
    };
  }

  const { data, error } = await cambiarEstadoPedidoBD(id, nuevo);

  if (error) return { status: 500, error: error.message };

  const pedido = data?.[0];

  if (!pedido) return { status: 404, error: 'Pedido no encontrado' };

  const { error: errorAviso } = await crearNotificacion({
    usuario_id: pedido.usuario_id,
    pedido_id: pedido.id,
    tipo: 'estado_pedido',
    titulo: `Pedido #${pedido.id}: ${nuevo}`,
    mensaje: MENSAJES[nuevo] || `Tu pedido cambió a ${nuevo}.`
  });

  if (errorAviso) console.error('Error aviso al cliente:', errorAviso.message);

  return { pedido };
};