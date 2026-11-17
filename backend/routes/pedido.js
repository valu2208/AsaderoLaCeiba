import { Router } from 'express';
import {
  crearPedido,
  listarPedidos,
  misPedidos,
  limpiarHistorial,
  actualizarEstado,
  cancelarPedido
} from '../controllers/pedido.js';

import {
  subirComprobante,
  listarComprobantes,
  revisarPago
} from '../controllers/pago.js';

import { uploadComprobante } from '../config/cloudinary.js';

import { listarPedidosAdmin } from '../controllers/pedidosAdmin.js';
import { reporteVentas } from '../controllers/reportes.js';

import {
  verificarToken,
  verificarAdmin,
  verificarNoAdmin
} from '../middlewares/authMiddleware.js';

const router = Router();

// Cliente: crear pedido.
router.post('/pedidos', verificarToken, verificarNoAdmin, crearPedido);

// Cliente: consultar sus pedidos visibles.
router.get('/pedidos/mis-pedidos', verificarToken, misPedidos);

// Cliente: ocultar todo su historial.
router.delete('/pedidos/mis-pedidos/historial', verificarToken, limpiarHistorial);

// Cliente: cancelar su propio pedido.
router.patch('/pedidos/:id/cancelar', verificarToken, cancelarPedido);

// Cliente: adjuntar comprobante de pago QR.
router.post(
  '/pedidos/:id/comprobante',
  verificarToken,
  verificarNoAdmin,
  uploadComprobante.single('comprobante'),
  subirComprobante
);

// Admin/Personal: consultar todos los pedidos.
router.get('/pedidos', verificarToken, verificarAdmin, listarPedidos);

// Admin: pedidos con cliente, mesa y platos.
router.get('/admin/pedidos', verificarToken, verificarAdmin, listarPedidosAdmin);

// Admin: consultar comprobantes pendientes.
router.get(
  '/admin/pagos/comprobantes',
  verificarToken,
  verificarAdmin,
  listarComprobantes
);

// Admin: aprobar o rechazar pagos.
router.patch(
  '/admin/pedidos/:id/pago',
  verificarToken,
  verificarAdmin,
  revisarPago
);

// Admin: reporte de ventas.
router.get('/admin/reportes', verificarToken, verificarAdmin, reporteVentas);

// Admin: cambiar estado del pedido.
router.put('/pedidos/:id/estado', verificarToken, verificarAdmin, actualizarEstado);

export default router;
