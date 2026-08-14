import express from 'express';
import {
    listarProductos,
    obtenerProducto,
    obtenerPorCat,
    crear,
    editar,
    eliminar
} from '../controllers/producto.js';

import {
    verificarToken,
    verificarAdmin
} from '../middlewares/authhMiddleware.js';

const router = express.Router();

// Rutas públicas

// GET - Obtener todos los productos
router.get('/', listarProductos);

// GET - Obtener producto por ID
router.get('/:id', obtenerProducto);

// GET - Obtener productos por categoría
router.get('/categoria/:categoria', obtenerPorCat);

// Rutas privadas (requieren token y rol de administrador)

// POST - Crear producto
router.post('/', verificarToken, verificarAdmin, crear);

// PUT - Actualizar producto
router.put('/:id', verificarToken, verificarAdmin, editar);

// DELETE - Eliminar producto
router.delete('/:id', verificarToken, verificarAdmin, eliminar);

export default router;