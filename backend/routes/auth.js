import { Router } from 'express';
import { iniciarSesion } from '../controllers/auth.js';

const router = Router();

// Iniciar sesión
router.post('/login', iniciarSesion);

export default router;