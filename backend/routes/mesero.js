import { Router } from 'express';

import {
    listarPedidosMesero,
    actualizarEstadoMesero
} from '../controllers/mesero.js';

import {
    verificarToken,
    verificarRol
} from '../middlewares/authMiddleware.js';

const router = Router();

// Ver los pedidos que hay que atender
router.get(
    '/pedidos',
    verificarToken,
    verificarRol('mesero', 'admin'),
    listarPedidosMesero
);

// Enviar a cocina o marcar como entregado
router.put(
    '/pedidos/:id/estado',
    verificarToken,
    verificarRol('mesero', 'admin'),
    actualizarEstadoMesero
);

export default router;