import { Router } from 'express';

import {
    iniciarSesion,
    solicitarRecuperacion,
    restablecerContrasena
} from '../controllers/auth.js';

const router = Router();

// Iniciar sesión
router.post('/login', iniciarSesion);

// Solicitar código de recuperación
router.post('/recuperar', solicitarRecuperacion);

// Restablecer contraseña
router.post('/restablecer', restablecerContrasena);

export default router;