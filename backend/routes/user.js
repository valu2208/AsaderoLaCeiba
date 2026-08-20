import { Router } from 'express';

import { verificarToken, verificarAdmin } from '../middlewares/authMiddleware.js';

import {
    registrarUsuario,
    listarUsuarios,
    obtenerUsuario,
    editarUsuario,
    eliminarUsuario
} from '../controllers/user.js';

const router = Router();

router.post('/', registrarUsuario);

router.get('/', verificarToken, verificarAdmin, listarUsuarios);

router.get('/:id', verificarToken, obtenerUsuario);

router.put('/:id', verificarToken, editarUsuario);

router.delete('/:id', verificarToken, verificarAdmin, eliminarUsuario);

export default router;