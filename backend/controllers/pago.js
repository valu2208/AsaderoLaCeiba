import {
  obtenerPedidoPagoBD,
  guardarComprobanteBD,
  listarComprobantesBD,
  actualizarPagoBD
} from '../models/pago.js';

import { subirComprobanteCloudinary } from '../config/cloudinary.js';

// El cliente sube el comprobante de su propio pedido.
export const subirComprobante = async (req, res) => {
  try {
    const { id } = req.params;

    if (!req.file) {
      return res.status(400).json({
        error: 'Debes adjuntar una imagen del comprobante.'
      });
    }

    const { data: pedido, error } = await obtenerPedidoPagoBD(id);

    if (error) {
      return res.status(500).json({ error: error.message });
    }

    if (!pedido) {
      return res.status(404).json({
        error: 'Pedido no encontrado.'
      });
    }

    if (String(pedido.usuario_id) !== String(req.usuario.id)) {
      return res.status(403).json({
        error: 'No puedes adjuntar comprobantes a pedidos de otros usuarios.'
      });
    }

    // El método de pago se define aquí, al subir el comprobante: el pedido
    // se crea como 'presencial' y guardarComprobanteBD lo cambia a 'qr'.

    if (pedido.estado_pago === 'Aprobado') {
      return res.status(400).json({
        error: 'Este pago ya fue aprobado.'
      });
    }

    const url = await subirComprobanteCloudinary(req.file.buffer);

    const { data, error: errorGuardar } =
      await guardarComprobanteBD(id, url);

    if (errorGuardar) {
      return res.status(500).json({
        error: errorGuardar.message
      });
    }

    return res.status(200).json({
      message: 'Comprobante enviado correctamente. Está pendiente de revisión.',
      pedido: data
    });
  } catch (error) {
    console.error('Error al subir comprobante:', error);

    return res.status(500).json({
      error: error.message || 'No se pudo subir el comprobante.'
    });
  }
};

// El administrador consulta los comprobantes pendientes.
export const listarComprobantes = async (req, res) => {
  try {
    const { data, error } = await listarComprobantesBD();

    if (error) {
      return res.status(500).json({ error: error.message });
    }

    return res.status(200).json(data || []);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

// El administrador aprueba o rechaza el pago.
export const revisarPago = async (req, res) => {
  try {
    const { id } = req.params;
    const { estado_pago, observacion } = req.body;

    if (!['Aprobado', 'Rechazado'].includes(estado_pago)) {
      return res.status(400).json({
        error: 'El estado debe ser Aprobado o Rechazado.'
      });
    }

    const { data: pedido, error: errorConsulta } =
      await obtenerPedidoPagoBD(id);

    if (errorConsulta) {
      return res.status(500).json({ error: errorConsulta.message });
    }

    if (!pedido) {
      return res.status(404).json({
        error: 'Pedido no encontrado.'
      });
    }

    if (!pedido.comprobante_pago_url) {
      return res.status(400).json({
        error: 'Este pedido todavía no tiene comprobante.'
      });
    }

    if (pedido.estado_pago === 'Aprobado') {
      return res.status(400).json({
        error: 'Este pago ya fue aprobado.'
      });
    }

    const { data, error } = await actualizarPagoBD(
      id,
      estado_pago,
      observacion
    );

    if (error) {
      return res.status(500).json({ error: error.message });
    }

    return res.status(200).json({
      message: estado_pago === 'Aprobado'
        ? 'Pago aprobado correctamente.'
        : 'Pago rechazado correctamente.',
      pedido: data
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};