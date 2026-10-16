import express from 'express';

import {
    listarProductos,
    listarProductosAdmin,
    obtenerProducto,
    obtenerPorCat,
    crear,
    editar,
    eliminar,
    activar,
    eliminarDefinitivamente
} from '../controllers/producto.js';

import {
    verificarToken,
    verificarAdmin
} from '../middlewares/authMiddleware.js';

import { upload } from '../config/cloudinary.js';

const router = express.Router();

// Rutas públicas
router.get('/', listarProductos);
router.get('/categoria/:categoria', obtenerPorCat);

// Rutas privadas para administradores
router.get(
    '/admin/todos',
    verificarToken,
    verificarAdmin,
    listarProductosAdmin
);

router.post(
    '/',
    verificarToken,
    verificarAdmin,
    upload.single('imagen'),
    crear
);

router.put(
    '/:id',
    verificarToken,
    verificarAdmin,
    upload.single('imagen'),
    editar
);

// Eliminar definitivamente un producto
router.delete(
    '/:id/definitivo',
    verificarToken,
    verificarAdmin,
    eliminarDefinitivamente
);

// Desactivar un producto
router.delete(
    '/:id',
    verificarToken,
    verificarAdmin,
    eliminar
);

// Reactivar un producto desactivado
router.patch(
    '/:id/activar',
    verificarToken,
    verificarAdmin,
    activar
);

// Obtener producto por ID
router.get('/:id', obtenerProducto);

export default router;