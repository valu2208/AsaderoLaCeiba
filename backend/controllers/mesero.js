import { obtenerPedidosPorEstadosBD } from '../models/pedido.js';
import { avanzarPedido, PASOS_MESERO } from '../utils/flujoPedido.js';

// Pedidos que el mesero debe atender, del más antiguo al más nuevo
const ESTADOS_MESERO = ['Pendiente', 'En cocina', 'En preparación', 'Listo'];

export const listarPedidosMesero = async (req, res) => {
    try {
        const { data, error } = await obtenerPedidosPorEstadosBD(ESTADOS_MESERO);

        if (error) {
            return res.status(500).json({ error: error.message });
        }

        return res.status(200).json(data);
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};

// El mesero envía a cocina (Pendiente -> En cocina) o entrega (Listo -> Entregado).
// Al enviar a cocina debe indicar la mesa: { estado: 'En cocina', mesa: 4 }
export const actualizarEstadoMesero = async (req, res) => {
    try {
        const { estado } = req.body;

        if (!estado) {
            return res.status(400).json({ error: 'El estado es requerido' });
        }

        const extras = {};

        if (estado === 'En cocina') {
            const mesa = Number(req.body.mesa);

            if (!Number.isInteger(mesa) || mesa <= 0) {
                return res.status(400).json({
                    error: 'Indica el número de mesa para enviar el pedido a cocina'
                });
            }

            extras.numero_mesa = mesa;
        }

        const resultado = await avanzarPedido(req.params.id, estado, PASOS_MESERO, extras);

        if (resultado.error) {
            return res.status(resultado.codigo).json({ error: resultado.error });
        }

        return res.status(200).json({
            message: 'Estado del pedido actualizado',
            pedido: resultado.pedido
        });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};