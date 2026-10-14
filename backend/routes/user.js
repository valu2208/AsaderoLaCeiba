import { Router } from 'express';

import {
    verificarToken,
    verificarAdmin,
    verificarPropietarioOAdmin
} from '../middlewares/authMiddleware.js';

import {
    registrarUsuario,
    verificarCorreo,
    reenviarCodigo,
    listarUsuarios,
    obtenerUsuario,
    editarUsuario,
    cambiarRolUsuario,
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

// Obtener usuario por ID (el propio usuario o un admin)
router.get('/:id', verificarToken, verificarPropietarioOAdmin, obtenerUsuario);

// Editar usuario (el propio usuario o un admin; el rol NO se cambia por aquí)
router.put('/:id', verificarToken, verificarPropietarioOAdmin, editarUsuario);

// Cambiar el rol de un usuario (solo admin)
router.put('/:id/rol', verificarToken, verificarAdmin, cambiarRolUsuario);

// Eliminar usuario
router.delete('/:id', verificarToken, verificarAdmin, eliminarUsuario);

export default router;