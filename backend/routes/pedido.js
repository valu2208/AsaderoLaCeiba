import { Router } from 'express';
import { 
  crearPedido, 
  listarPedidos, 
  misPedidos, 
  actualizarEstado 
} from '../controllers/pedido.js';
import { verificarToken, verificarAdmin } from '../middlewares/authMiddleware.js';

const router = Router();

// Endpoint para que un cliente cree un pedido
router.post('/pedidos', verificarToken, crearPedido);

// Endpoint para que el usuario vea solo SUS pedidos
router.get('/pedidos/mis-pedidos', verificarToken, misPedidos);

// Endpoint para que el Admin/Personal vea TODOS los pedidos del asadero
router.get('/pedidos', verificarToken, verificarAdmin, listarPedidos);

// Endpoint para cambiar el estado del pedido (ej. de 'pendiente' a 'entregado')
router.put('/pedidos/:id/estado', verificarToken, verificarAdmin, actualizarEstado);

export default router;