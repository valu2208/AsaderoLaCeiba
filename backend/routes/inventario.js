import { Router } from 'express';
import { verificarToken, verificarRol } from '../middlewares/authMiddleware.js';
import {
  listarInventario,
  actualizarStock,
  crearIngrediente,
  editarIngrediente,
  eliminarIngrediente
} from '../controllers/inventario.js';

const router = Router();
const personal = [verificarToken, verificarRol('cocinero', 'admin')];
const soloAdmin = [verificarToken, verificarRol('admin')];

// Cocinero y admin
router.get('/', ...personal, listarInventario);
router.put('/:id/stock', ...personal, actualizarStock);

// Solo admin
router.post('/', ...soloAdmin, crearIngrediente);
router.put('/:id', ...soloAdmin, editarIngrediente);
router.delete('/:id', ...soloAdmin, eliminarIngrediente);

export default router;