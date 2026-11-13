
import { Router } from 'express';

import {
    iniciarSesion,
    solicitarRecuperacion,
    restablecerContrasena,
    renovarSesion,
    cerrarSesion
} from '../controllers/auth.js';

import {
    autenticarConGoogle
} from '../controllers/googleAuth.controller.js';

const router = Router();

// Iniciar sesión
router.post('/login', iniciarSesion);

// Autenticación con Google
router.post('/google', autenticarConGoogle);

// Renovar sesión
router.post('/refresh', renovarSesion);

// Cerrar sesión
router.post('/logout', cerrarSesion);

// Solicitar código de recuperación
router.post('/recuperar', solicitarRecuperacion);

// Restablecer contraseña
router.post('/restablecer', restablecerContrasena);

export default router;
