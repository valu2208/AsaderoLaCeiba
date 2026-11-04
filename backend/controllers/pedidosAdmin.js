import { obtenerPedidosPorEstadosBD } from '../models/pedido.js';

// El admin ve todos los pedidos, con cliente, mesa y platos
const ESTADOS_ADMIN = ['Pendiente', 'En cocina', 'En preparación', 'Listo', 'Entregado'];

export const listarPedidosAdmin = async (req, res) => {
    try {
        const { data, error } = await obtenerPedidosPorEstadosBD(ESTADOS_ADMIN);

        if (error) {
            return res.status(500).json({ error: error.message });
        }

        return res.status(200).json(data);
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};