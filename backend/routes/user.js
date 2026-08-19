import { Router } from 'express';

import {
    registrarUsuario,
    listarUsuarios,
    obtenerUsuario,
    editarUsuario,
    eliminarUsuario
} from '../controllers/user.js';

const router = Router();

// Registrar usuario
router.post('/', registrarUsuario);

// Obtener todos los usuarios
router.get('/', listarUsuarios);

// Obtener usuario por ID
router.get('/:id', obtenerUsuario);

// Actualizar usuario
router.put('/:id', editarUsuario);

// Eliminar usuario
router.delete('/:id', eliminarUsuario);

export default router;