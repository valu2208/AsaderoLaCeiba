import { Router } from 'express';

import {
    verificarToken,
    verificarAdmin
} from '../middlewares/authMiddleware.js';

import {
    registrarUsuario,
    verificarCorreo,
    reenviarCodigo,
    listarUsuarios,
    obtenerUsuario,
    editarUsuario,
    eliminarUsuario
} from '../controllers/user.js';

const router = Router();

// Registrar usuario
router.post('/', registrarUsuario);

// Verificar correo electrónico
router.post('/verificar', verificarCorreo);

// Reenviar código de verificación
router.post('/reenviar-codigo', reenviarCodigo);

// Obtener todos los usuarios
router.get('/', verificarToken, verificarAdmin, listarUsuarios);

// Obtener usuario por ID
router.get('/:id', verificarToken, obtenerUsuario);

// Editar usuario
router.put('/:id', verificarToken, editarUsuario);

// Eliminar usuario
router.delete('/:id', verificarToken, verificarAdmin, eliminarUsuario);

export default router;