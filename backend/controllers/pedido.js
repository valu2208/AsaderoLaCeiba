
import {
  crearPedidoBD,
  obtenerTodosPedidosBD,
  obtenerPedidosPorUsuarioBD,
  cambiarEstadoPedidoBD,
  cancelarPedidoBD,
  ocultarHistorialPedidosBD
} from '../models/pedido.js';

import { crearNotificacion, avisarRol } from '../models/notificacion.js';

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

    if (!Array.isArray(productos) || productos.length === 0) {
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

    const { data, error } = await crearPedidoBD(datosPedido, productos);

    if (error) {
      return res.status(500).json({
        error: error.message || 'Error al registrar el pedido'
      });
    }

    const { error: errorNotificacion } = await crearNotificacion({
      usuario_id,
      pedido_id: data.id,
      tipo: 'pedido',
      titulo: '¡Pedido recibido!',
      mensaje: 'Hemos recibido tu pedido y pronto comenzaremos a prepararlo. ¡Gracias por elegir Asadero La Ceiba!'
    });

    if (errorNotificacion) {
      console.error('Error al crear la notificación:', errorNotificacion.message);
    }

    const { error: errorMeseros } = await avisarRol('mesero', {
      pedido_id: data.id,
      tipo: 'pedido',
      titulo: `Nuevo pedido #${data.id}`,
      mensaje: 'Un cliente hizo un pedido. Revísalo y envíalo a cocina.'
    });

    if (errorMeseros) {
      console.error('Error al avisar a los meseros:', errorMeseros.message);
    }

    return res.status(201).json({
      message: 'Pedido creado exitosamente',
      pedido: data
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
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
    return res.status(500).json({ error: error.message });
  }
};

// Historial de pedidos del usuario autenticado
export const misPedidos = async (req, res) => {
  try {
    const { data, error } = await obtenerPedidosPorUsuarioBD(req.usuario.id);

    if (error) {
      return res.status(500).json({ error: error.message });
    }

    return res.status(200).json(data);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

// Ocultar el historial del usuario sin eliminar sus pedidos
export const limpiarHistorial = async (req, res) => {
  try {
    const { data, error } = await ocultarHistorialPedidosBD(req.usuario.id);

    if (error) {
      return res.status(500).json({ error: error.message });
    }

    return res.status(200).json({
      message: 'Historial limpiado correctamente',
      pedidos_ocultos: data?.length || 0
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

// Cancelar un pedido propio que siga pendiente
export const cancelarPedido = async (req, res) => {
  try {
    const { id } = req.params;

    const { data, error } = await cancelarPedidoBD(id, req.usuario.id);

    if (error) {
      return res.status(500).json({ error: error.message });
    }

    if (!data) {
      return res.status(400).json({
        error: 'No se pudo cancelar. El pedido no existe, no te pertenece o ya no está pendiente.'
      });
    }

    return res.status(200).json({
      message: 'Pedido cancelado correctamente',
      pedido: data
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

// Cambiar estado del pedido
export const actualizarEstado = async (req, res) => {
  try {
    const { id } = req.params;
    const { estado } = req.body;

    if (!estado) {
      return res.status(400).json({
        error: 'El nuevo estado es requerido'
      });
    }

    const { data: pedidos, error: errorConsulta } =
      await obtenerTodosPedidosBD();

    if (errorConsulta) {
      return res.status(500).json({ error: errorConsulta.message });
    }

    const pedidoAnterior = (pedidos || []).find(
      pedido => String(pedido.id) === String(id)
    );

    if (!pedidoAnterior) {
      return res.status(404).json({ error: 'Pedido no encontrado' });
    }

    const { data, error } = await cambiarEstadoPedidoBD(id, estado);

    if (error) {
      return res.status(500).json({ error: error.message });
    }

    const pedidoActualizado = data?.[0];

    if (!pedidoActualizado) {
      return res.status(404).json({
        error: 'No se encontró el pedido actualizado'
      });
    }

    if (pedidoAnterior.estado !== estado) {
      const nombresEstado = {
        'Pendiente': 'Recibido',
        'Recibido': 'Recibido',
        'En cocina': 'En cocina',
        'En preparación': 'En cocina',
        'Listo': 'Listo',
        'Entregado': 'Entregado'
      };

      const mensajesEstado = {
        'Pendiente': 'Hemos recibido tu pedido y pronto comenzaremos a prepararlo.',
        'Recibido': 'Hemos recibido tu pedido y pronto comenzaremos a prepararlo.',
        'En cocina': 'Tu pedido está en cocina y pronto estará listo.',
        'En preparación': 'La cocina está preparando tu pedido.',
        'Listo': '¡Tu pedido está listo! Puedes pasar a recogerlo.',
        'Entregado': 'Tu pedido ha sido entregado. ¡Gracias por elegirnos!'
      };

      const { error: errorNotificacion } = await crearNotificacion({
        usuario_id: pedidoActualizado.usuario_id,
        pedido_id: pedidoActualizado.id,
        tipo: 'estado_pedido',
        titulo: `Pedido #${pedidoActualizado.id}: ${nombresEstado[estado] || estado}`,
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
    return res.status(500).json({ error: error.message });
  }
};
