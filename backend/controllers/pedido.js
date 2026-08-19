import { 
  crearPedidoBD, 
  obtenerTodosPedidosBD, 
  obtenerPedidosPorUsuarioBD, 
  cambiarEstadoPedidoBD 
} from '../models/pedido.js';

// Crear un pedido
export const crearPedido = async (req, res) => {
  try {
    const { 
      numero_mesa, 
      total, 
      moneda_pago, 
      total_moneda_extranjera, 
      metodo_pago, 
      telefono, 
      notas, 
      productos 
    } = req.body;

    const usuario_id = req.usuario.id; // Del token JWT

    if (!productos || productos.length === 0) {
      return res.status(400).json({ error: 'El pedido debe incluir al menos un producto' });
    }

    const datosPedido = {
      usuario_id,
      numero_mesa,
      total,
      moneda_pago,
      total_moneda_extranjera,
      metodo_pago,
      telefono,
      notas
    };

    const { data, error } = await crearPedidoBD(datosPedido, productos);

    if (error) return res.status(500).json({ error: error.message || 'Error al registrar el pedido' });
    return res.status(201).json({ message: 'Pedido creado exitosamente', pedido: data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

// Listar todos los pedidos
export const listarPedidos = async (req, res) => {
  try {
    const { data, error } = await obtenerTodosPedidosBD();
    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json(data);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

// Historial de pedidos del usuario autenticado
export const misPedidos = async (req, res) => {
  try {
    const usuario_id = req.usuario.id;
    const { data, error } = await obtenerPedidosPorUsuarioBD(usuario_id);
    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json(data);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

// Cambiar estado
export const actualizarEstado = async (req, res) => {
  try {
    const { id } = req.params;
    const { estado } = req.body;

    if (!estado) {
      return res.status(400).json({ error: 'El nuevo estado es requerido' });
    }

    const { data, error } = await cambiarEstadoPedidoBD(id, estado);
    if (error) return res.status(500).json({ error: error.message });
    return res.status(200).json({ message: 'Estado actualizado', pedido: data[0] });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};