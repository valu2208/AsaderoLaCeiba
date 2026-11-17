import {
  crearPedidoBD,
  obtenerTodosPedidosBD,
  obtenerPedidosPorUsuarioBD,
  cambiarEstadoPedidoBD
} from '../models/pedido.js';

import { crearNotificacion, avisarRol } from '../models/notificacion.js';

// AJUSTA esta ruta a donde esté tu cliente de Supabase
// (mira los imports de la parte de arriba de models/pedido.js)
import { supabase } from '../config/supabase.js';

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

    // Aviso a todos los meseros: hay un pedido nuevo
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
    return res.status(500).json({
      error: error.message
    });
  }
};

// Subir comprobante de pago (Nequi / QR)
export const subirComprobante = async (req, res) => {
  try {
    const pedidoId = Number(req.params.id);
    const usuario_id = req.usuario.id;

    if (!Number.isInteger(pedidoId)) {
      return res.status(400).json({ error: 'Id de pedido inválido' });
    }

    if (!req.file) {
      return res.status(400).json({
        error: 'No se recibió ninguna imagen'
      });
    }

    // Verificar que el pedido exista y sea del usuario autenticado
    const { data: pedido, error: errorPedido } = await supabase
      .from('pedidos')
      .select('id, usuario_id')
      .eq('id', pedidoId)
      .maybeSingle();

    if (errorPedido) {
      return res.status(500).json({ error: errorPedido.message });
    }

    if (!pedido || String(pedido.usuario_id) !== String(usuario_id)) {
      return res.status(404).json({ error: 'Pedido no encontrado' });
    }

    // Subir la imagen a Supabase Storage
    const extension =
      (req.file.originalname.split('.').pop() || 'jpg').toLowerCase();
    const nombreArchivo = `pedido-${pedidoId}-${Date.now()}.${extension}`;

    const { error: errorSubida } = await supabase.storage
      .from('comprobantes')
      .upload(nombreArchivo, req.file.buffer, {
        contentType: req.file.mimetype
      });

    if (errorSubida) {
      return res.status(500).json({ error: errorSubida.message });
    }

    const { data: urlData } = supabase.storage
      .from('comprobantes')
      .getPublicUrl(nombreArchivo);

    const { error: errorActualizar } = await supabase
      .from('pedidos')
      .update({ comprobante_url: urlData.publicUrl })
      .eq('id', pedidoId);

    if (errorActualizar) {
      return res.status(500).json({ error: errorActualizar.message });
    }

    return res.status(200).json({
      message: 'Comprobante recibido',
      comprobante_url: urlData.publicUrl
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
        'En cocina': 'Tu pedido fue enviado a la cocina.',
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