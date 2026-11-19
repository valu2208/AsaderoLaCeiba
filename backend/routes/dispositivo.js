import { Router } from 'express';
import { verificarToken } from '../middlewares/authMiddleware.js';
import { registrarDispositivo, quitarDispositivo } from '../controllers/dispositivo.js';

const router = Router();

router.post('/', verificarToken, registrarDispositivo);
router.delete('/', verificarToken, quitarDispositivo);

export default router;