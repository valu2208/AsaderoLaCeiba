import { Router } from 'express';
import { verificarToken, verificarRol } from '../middlewares/authMiddleware.js';
import { listarInventario, actualizarStock } from '../controllers/inventario.js';

const router = Router();
const personal = [verificarToken, verificarRol('cocinero', 'admin')];

router.get('/', ...personal, listarInventario);
router.put('/:id/stock', ...personal, actualizarStock);

export default router;
