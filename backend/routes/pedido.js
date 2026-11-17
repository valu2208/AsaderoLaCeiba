import { Router } from 'express';
import multer from 'multer';
import path from 'path';
import fs from 'fs';
import {
  crearPedido,
  listarPedidos,
  misPedidos,
  actualizarEstado,
  subirComprobante,
} from '../controllers/pedido.js';
import { listarPedidosAdmin } from '../controllers/pedidosAdmin.js';
import { reporteVentas } from '../controllers/reportes.js';
import { verificarToken, verificarAdmin } from '../middlewares/authMiddleware.js';

const router = Router();

// Carpeta donde se guardan los comprobantes
const carpeta = 'uploads/comprobantes';
fs.mkdirSync(carpeta, { recursive: true });

const upload = multer({
  storage: multer.diskStorage({
    destination: carpeta,
    filename: (req, file, cb) => {
      const ext = path.extname(file.originalname) || '.jpg';
      cb(null, `pedido-${req.params.id}-${Date.now()}${ext}`);
    },
  }),
  limits: { fileSize: 5 * 1024 * 1024 }, // 5 MB
  fileFilter: (req, file, cb) => {
    if (file.mimetype.startsWith('image/')) cb(null, true);
    else cb(new Error('Solo se permiten imágenes.'));
  },
});

// Cliente crea un pedido
router.post('/pedidos', verificarToken, crearPedido);

// Cliente sube el comprobante de pago de su pedido
router.post(
  '/pedidos/:id/comprobante',
  verificarToken,
  (req, res, next) => {
    upload.single('comprobante')(req, res, (err) => {
      if (err) return res.status(400).json({ error: err.message });
      next();
    });
  },
  subirComprobante
);

// El usuario ve solo SUS pedidos
router.get('/pedidos/mis-pedidos', verificarToken, misPedidos);

// Admin/Personal ve TODOS los pedidos
router.get('/pedidos', verificarToken, verificarAdmin, listarPedidos);

// Admin: pedidos con cliente, mesa y platos
router.get('/admin/pedidos', verificarToken, verificarAdmin, listarPedidosAdmin);

// Admin: reporte de ventas
router.get('/admin/reportes', verificarToken, verificarAdmin, reporteVentas);

// Cambiar el estado del pedido
router.put('/pedidos/:id/estado', verificarToken, verificarAdmin, actualizarEstado);

export default router;