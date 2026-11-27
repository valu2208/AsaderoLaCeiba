import { Router } from 'express';
import { verificarToken } from '../middlewares/authMiddleware.js';

import {
    listarNotificaciones,
    leerNotificacion,
    contarNoLeidas,
    borrarNotificaciones,
    pedidoDeNotificacion
} from '../controllers/notificacion.js';

const router = Router();

// Consultar las notificaciones.
router.get('/', verificarToken, listarNotificaciones);

// Consultar la cantidad de notificaciones no leídas.
router.get('/no-leidas', verificarToken, contarNoLeidas);

// Marcar una notificación como leída.
router.patch('/:id/leida', verificarToken, leerNotificacion);

// Pedido relacionado con una notificación.
router.get('/:id/pedido', verificarToken, pedidoDeNotificacion);

// Eliminar las notificaciones leídas del usuario.
router.delete('/', verificarToken, borrarNotificaciones);

export default router;