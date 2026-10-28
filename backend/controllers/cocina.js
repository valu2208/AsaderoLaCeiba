
import {
    obtenerTodosPedidosBD,
    cambiarEstadoPedidoBD
} from '../models/pedido.js';

import { crearNotificacion } from '../models/notificacion.js';

// Obtener pedidos para cocina
export const listarPedidosCocina = async (req, res) => {
    try {
        const { data, error } = await obtenerTodosPedidosBD();

        if (error) {
            return res.status(500).json({
                error: error.message
            });
        }

        return res.status(200).json(data);
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

// Actualizar estado de un pedido desde cocina
export const actualizarEstadoCocina = async (req, res) => {
    try {
        const { id } = req.params;
        const { estado } = req.body;

        if (!estado) {
            return res.status(400).json({
                error: 'El estado es requerido'
            });
        }

        const estadosPermitidos = [
            'Pendiente',
            'En preparación',
            'Listo',
            'Entregado'
        ];

        if (!estadosPermitidos.includes(estado)) {
            return res.status(400).json({
                error: 'Estado no válido'
            });
        }

        // Consultar el pedido para identificar al usuario propietario
        const { data: pedidos, error: errorConsulta } =
            await obtenerTodosPedidosBD();

        if (errorConsulta) {
            return res.status(500).json({
                error: errorConsulta.message
            });
        }

        const pedidoAnterior = pedidos.find(
            pedido => String(pedido.id) === String(id)
        );

        if (!pedidoAnterior) {
            return res.status(404).json({
                error: 'Pedido no encontrado'
            });
        }

        const { data, error } = await cambiarEstadoPedidoBD(id, estado);

        if (error) {
            return res.status(500).json({
                error: error.message
            });
        }

        const pedidoActualizado = data?.[0];

        if (!pedidoActualizado) {
            return res.status(404).json({
                error: 'No se encontró el pedido actualizado'
            });
        }

        // Notificar solo cuando el estado realmente cambie
        if (pedidoAnterior.estado !== estado) {
            const mensajesEstado = {
                'Pendiente': 'Tu pedido está pendiente.',
                'En preparación': 'La cocina está preparando tu pedido.',
                'Listo': 'Tu pedido está listo.',
                'Entregado': 'Tu pedido ha sido entregado.'
            };

            const { error: errorNotificacion } = await crearNotificacion({
                usuario_id: pedidoActualizado.usuario_id,
                pedido_id: pedidoActualizado.id,
                tipo: 'estado_pedido',
                titulo: `Pedido #${pedidoActualizado.id}: ${estado}`,
                mensaje: mensajesEstado[estado] || `El estado de tu pedido cambió a ${estado}.`
            });

            if (errorNotificacion) {
                console.error(
                    'Error al crear la notificación del estado:',
                    errorNotificacion.message
                );
            }
        }

        return res.status(200).json({
            message: 'Estado del pedido actualizado',
            pedido: pedidoActualizado
        });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};
