import {
    obtenerTodos,
    obtenerPorId,
    obtenerPorCategoria,
    crearProducto,
    actualizarProducto,
    eliminarProducto
} from '../models/producto.js';

export const listarProductos = async (req, res) => {
    try {
        const { data, error } = await obtenerTodos();

        if (error) {
            return res.status(500).json({
                error: 'Error al obtener productos'
            });
        }

        return res.status(200).json(data);

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

export const obtenerProducto = async (req, res) => {
    try {
        const { id } = req.params;

        const { data, error } = await obtenerPorId(id);

        if (error || !data) {
            return res.status(404).json({
                error: 'Producto no encontrado'
            });
        }

        return res.status(200).json(data);

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

export const obtenerPorCat = async (req, res) => {
    try {
        const { categoria } = req.params;

        const { data, error } = await obtenerPorCategoria(categoria);

        if (error) {
            return res.status(500).json({
                error: 'Error al obtener productos'
            });
        }

        return res.status(200).json(data);

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

export const crear = async (req, res) => {
    try {
        const {
            nombre,
            nombre_en,
            descripcion,
            description_en,
            presentacion,
            precio,
            stock,
            categoria,
            disponible
        } = req.body;

        if (!nombre || !precio) {
            return res.status(400).json({
                error: 'nombre y precio son requeridos'
            });
        }

        const imagen_url = req.file ? req.file.path : null;

        const { data, error } = await crearProducto({
            nombre,
            nombre_en,
            descripcion,
            description_en,
            presentacion,
            precio,
            stock,
            imagen_url,
            categoria,
            disponible
        });

        if (error) {
            return res.status(500).json({
                error: 'Error al crear producto'
            });
        }

        return res.status(201).json({
            message: 'Producto creado',
            producto: data
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

export const editar = async (req, res) => {
    try {
        const { id } = req.params;

        const datosActualizados = {
            ...req.body
        };

        if (req.file) {
            datosActualizados.imagen_url = req.file.path;
        }

        const { data, error } = await actualizarProducto(
            id,
            datosActualizados
        );

        if (error) {
            return res.status(500).json({
                error: 'Error al actualizar producto'
            });
        }

        return res.status(200).json({
            message: 'Producto actualizado',
            producto: data
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

export const eliminar = async (req, res) => {
    try {
        const { id } = req.params;

        const { error } = await eliminarProducto(id);

        if (error) {
            return res.status(500).json({
                error: 'Error al eliminar producto'
            });
        }

        return res.status(200).json({
            message: 'Producto eliminado'
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};