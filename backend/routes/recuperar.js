import { Router } from 'express';

import {
    solicitarRecuperacion,
    restablecerPassword
} from '../controllers/recuperar.js';

const router = Router();

// Solicitar código de recuperación
router.post('/solicitar', solicitarRecuperacion);

// Restablecer contraseña
router.post('/restablecer', restablecerPassword);

export default router;