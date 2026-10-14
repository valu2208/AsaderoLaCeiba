import { Router } from 'express';
 
import {
    listarPedidosCocina,
    actualizarEstadoCocina
} from '../controllers/cocina.js';
 
import {
    verificarToken,
    verificarRol
} from '../middlewares/authMiddleware.js';
 
const router = Router();
 
// Ver pedidos para cocina
router.get(
    '/pedidos',
    verificarToken,
    verificarRol('cocinero', 'admin'),
    listarPedidosCocina
);
 
// Actualizar estado del pedido
router.put(
    '/pedidos/:id/estado',
    verificarToken,
    verificarRol('cocinero', 'admin'),
    actualizarEstadoCocina
);
 
export default router;