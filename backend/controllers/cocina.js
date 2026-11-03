import { obtenerPedidosPorEstadosBD } from '../models/pedido.js';
import { avanzarPedido, PASOS_COCINA } from '../utils/flujoPedido.js';

// Pedidos que le llegan a cocina: los que el mesero ya envió
const ESTADOS_COCINA = ['En cocina', 'En preparación'];

// Obtener pedidos para cocina
export const listarPedidosCocina = async (req, res) => {
    try {
        const { data, error } = await obtenerPedidosPorEstadosBD(ESTADOS_COCINA);

        if (error) {
            return res.status(500).json({ error: error.message });
        }

        return res.status(200).json(data);
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};

// Cocina empieza (En preparación) o termina el pedido (Listo)
export const actualizarEstadoCocina = async (req, res) => {
    try {
        const { estado } = req.body;

        if (!estado) {
            return res.status(400).json({ error: 'El estado es requerido' });
        }

        const resultado = await avanzarPedido(req.params.id, estado, PASOS_COCINA);

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