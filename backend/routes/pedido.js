
import { Router } from 'express';

import {
  crearPedido,
  listarPedidos,
  misPedidos,
  limpiarHistorial,
  actualizarEstado,
  cancelarPedido
} from '../controllers/pedido.js';

import { listarPedidosAdmin } from '../controllers/pedidosAdmin.js';
import { reporteVentas } from '../controllers/reportes.js';

import {
  verificarToken,
  verificarAdmin
} from '../middlewares/authMiddleware.js';

const router = Router();

// Cliente: crear pedido
router.post('/pedidos', verificarToken, crearPedido);

// Cliente: consultar sus pedidos visibles
router.get('/pedidos/mis-pedidos', verificarToken, misPedidos);

// Cliente: ocultar todo su historial
router.delete('/pedidos/mis-pedidos/historial', verificarToken, limpiarHistorial);

// Cliente: cancelar su propio pedido
router.patch('/pedidos/:id/cancelar', verificarToken, cancelarPedido);

// Admin/Personal: consultar todos los pedidos
router.get('/pedidos', verificarToken, verificarAdmin, listarPedidos);

// Admin: pedidos con cliente, mesa y platos
router.get('/admin/pedidos', verificarToken, verificarAdmin, listarPedidosAdmin);

// Admin: reporte de ventas
router.get('/admin/reportes', verificarToken, verificarAdmin, reporteVentas);

// Admin: cambiar estado del pedido
router.put('/pedidos/:id/estado', verificarToken, verificarAdmin, actualizarEstado);

export default router;
