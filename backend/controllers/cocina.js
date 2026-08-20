import {
    obtenerTodosPedidosBD,
    cambiarEstadoPedidoBD
} from '../models/pedido.js';

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

        const { data, error } = await cambiarEstadoPedidoBD(
            id,
            estado
        );

        if (error) {
            return res.status(500).json({
                error: error.message
            });
        }

        return res.status(200).json({
            message: 'Estado del pedido actualizado',
            pedido: data[0]
        });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};