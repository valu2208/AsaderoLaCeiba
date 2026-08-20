import { Router } from 'express';

import {
    listarPedidosCocina,
    actualizarEstadoCocina
} from '../controllers/cocina.js';

import {
    verificarToken
} from '../middlewares/authMiddleware.js';

const router = Router();

// Ver pedidos para cocina
router.get('/pedidos', verificarToken, listarPedidosCocina);

// Actualizar estado del pedido
router.put(
    '/pedidos/:id/estado',
    verificarToken,
    actualizarEstadoCocina
);

export default router;