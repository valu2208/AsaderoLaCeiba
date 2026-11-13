
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
    eliminarUsuario,
    actualizarFotoPerfil
} from '../controllers/user.js';

import { uploadAvatar } from '../config/cloudinary.js';

const router = Router();

// Registro y verificación
router.post('/', registrarUsuario);
router.post('/verificar', verificarCorreo);
router.post('/reenviar-codigo', reenviarCodigo);

// Listar usuarios: solo administrador
router.get('/', verificarToken, verificarAdmin, listarUsuarios);

// Actualizar foto del usuario autenticado
router.post(
    '/avatar',
    verificarToken,
    uploadAvatar.single('avatar'),
    actualizarFotoPerfil
);

// Consultar y editar usuarios
router.get('/:id', verificarToken, verificarPropietarioOAdmin, obtenerUsuario);
router.put('/:id', verificarToken, verificarPropietarioOAdmin, editarUsuario);

// Cambiar rol: solo administrador
router.put('/:id/rol', verificarToken, verificarAdmin, cambiarRolUsuario);

// Eliminar usuario
router.delete('/:id', verificarToken, verificarPropietarioOAdmin, eliminarUsuario);

export default router;
