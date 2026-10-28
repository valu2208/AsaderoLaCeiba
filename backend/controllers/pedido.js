
import {
  crearPedidoBD,
  obtenerTodosPedidosBD,
  obtenerPedidosPorUsuarioBD,
  cambiarEstadoPedidoBD
} from '../models/pedido.js';

import { crearNotificacion } from '../models/notificacion.js';

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

    const usuario_id = req.usuario.id;

    if (!productos || productos.length === 0) {
      return res.status(400).json({
        error: 'El pedido debe incluir al menos un producto'
      });
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

    const { data, error } = await crearPedidoBD(
      datosPedido,
      productos
    );

    if (error) {
      return res.status(500).json({
        error: error.message || 'Error al registrar el pedido'
      });
    }

    const { error: errorNotificacion } = await crearNotificacion({
      usuario_id,
      pedido_id: data.id,
      tipo: 'pedido',
      titulo: 'Pedido recibido',
      mensaje: `Tu pedido #${data.id} se registró correctamente.`
    });

    if (errorNotificacion) {
      console.error(
        'Error al crear la notificación del pedido:',
        errorNotificacion.message
      );
    }

    return res.status(201).json({
      message: 'Pedido creado exitosamente',
      pedido: data
    });
  } catch (error) {
    return res.status(500).json({
      error: error.message
    });
  }
};

// Listar todos los pedidos
export const listarPedidos = async (req, res) => {
  try {
    const { data, error } = await obtenerTodosPedidosBD();

    if (error) {
      return res.status(500).json({ error: error.message });
    }

    return res.status(200).json(data);
  } catch (error) {
    return res.status(500).json({
      error: error.message
    });
  }
};

// Historial de pedidos del usuario autenticado
export const misPedidos = async (req, res) => {
  try {
    const usuario_id = req.usuario.id;

    const { data, error } = await obtenerPedidosPorUsuarioBD(
      usuario_id
    );

    if (error) {
      return res.status(500).json({ error: error.message });
    }

    return res.status(200).json(data);
  } catch (error) {
    return res.status(500).json({
      error: error.message
    });
  }
};

// Cambiar estado
export const actualizarEstado = async (req, res) => {
  try {
    const { id } = req.params;
    const { estado } = req.body;

    if (!estado) {
      return res.status(400).json({
        error: 'El nuevo estado es requerido'
      });
    }

    // Consultar el pedido antes de actualizarlo
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

    const { data, error } = await cambiarEstadoPedidoBD(
      id,
      estado
    );

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

    // Notificar únicamente si el estado cambió
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
        mensaje: mensajesEstado[estado] ||
          `El estado de tu pedido cambió a ${estado}.`
      });

      if (errorNotificacion) {
        console.error(
          'Error al crear la notificación del estado:',
          errorNotificacion.message
        );
      }
    }

    return res.status(200).json({
      message: 'Estado actualizado',
      pedido: pedidoActualizado
    });
  } catch (error) {
    return res.status(500).json({
      error: error.message
    });
  }
};
