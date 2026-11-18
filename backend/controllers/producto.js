
import {
    obtenerTodos,
    obtenerTodosAdmin,
    obtenerMasPedidos,
    obtenerPorId,
    obtenerPorCategoria,
    crearProducto,
    actualizarProducto,
    eliminarProducto,
    activarProducto,
    eliminarProductoDefinitivamente
} from '../models/producto.js';

import { traducirProducto } from '../utils/traducirProducto.js';

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

// "lunes,martes" -> ['lunes', 'martes']
const listaDias = (valor) =>
    typeof valor === 'string'
        ? valor.split(',').map((d) => d.trim()).filter(Boolean)
        : valor;

export const listarMasPedidos = async (req, res) => {
    try {
        const { data, error } = await obtenerMasPedidos();

        if (error) {
            return res.status(500).json({
                error: 'Error al obtener los más pedidos'
            });
        }

        return res.status(200).json(data);
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

export const listarProductosAdmin = async (req, res) => {
    try {
        const { data, error } = await obtenerTodosAdmin({
            masPedido:
                req.query.mas_pedido === undefined
                    ? undefined
                    : req.query.mas_pedido === 'true',
            categoria: req.query.categoria,
            dia: req.query.dia
        });

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
        const { data, error } = await obtenerPorCategoria(
            categoria,
            req.query.dia
        );

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
            descripcion,
            presentacion,
            precio,
            stock,
            categoria,
            disponible,
            mas_pedido,
            dias
        } = req.body;

        console.log('DATOS RECIBIDOS', req.body);

        if (!nombre || !precio) {
            return res.status(400).json({
                error: 'nombre y precio son requeridos'
            });
        }

        // Generar automáticamente las traducciones.
        const traducciones = await traducirProducto({
            nombre,
            descripcion
        });

        const imagen_url = req.file ? req.file.path : null;

        const { data, error } = await crearProducto({
            nombre,
            descripcion,
            ...traducciones,
            presentacion,
            precio,
            stock,
            imagen_url,
            categoria,
            disponible,
            mas_pedido,
            dias: listaDias(dias) || []
        });

        if (error) {
            console.error('ERROR AL CREAR PRODUCTO:', error);

            return res.status(500).json({
                error: 'Error al crear producto'
            });
        }

        return res.status(201).json({
            message: 'Producto creado',
            producto: data
        });
    } catch (error) {
        console.error('ERROR EN crear:', error);

        return res.status(500).json({
            error: error.message
        });
    }
};

export const editar = async (req, res) => {
    try {
        const { id } = req.params;
        const datosActualizados = { ...req.body };

        if (datosActualizados.dias !== undefined) {
            datosActualizados.dias = listaDias(datosActualizados.dias);
        }

        if (req.file) {
            datosActualizados.imagen_url = req.file.path;
        }

        // Las traducciones las controla el backend.
        delete datosActualizados.nombre_en;
        delete datosActualizados.description_en;
        delete datosActualizados.nombre_pt;
        delete datosActualizados.descripcion_pt;

        const cambiaNombre =
            datosActualizados.nombre !== undefined;

        const cambiaDescripcion =
            datosActualizados.descripcion !== undefined;

        if (cambiaNombre || cambiaDescripcion) {
            const { data: productoActual, error: errorProducto } =
                await obtenerPorId(id);

            if (errorProducto || !productoActual) {
                return res.status(404).json({
                    error: 'Producto no encontrado'
                });
            }

            const producto = Array.isArray(productoActual)
                ? productoActual[0]
                : productoActual;

            if (!producto) {
                return res.status(404).json({
                    error: 'Producto no encontrado'
                });
            }

            const nombreFinal = cambiaNombre
                ? datosActualizados.nombre
                : producto.nombre;

            const descripcionFinal = cambiaDescripcion
                ? datosActualizados.descripcion
                : producto.descripcion;

            const nombreCambio =
                nombreFinal !== producto.nombre;

            const descripcionCambio =
                descripcionFinal !== producto.descripcion;

            if (nombreCambio || descripcionCambio) {
                const traducciones = await traducirProducto({
                    nombre: nombreFinal,
                    descripcion: descripcionFinal
                });

                Object.assign(datosActualizados, traducciones);
            }
        }

        const { data, error } = await actualizarProducto(
            id,
            datosActualizados
        );

        if (error) {
            console.error('ERROR AL ACTUALIZAR PRODUCTO:', error);

            return res.status(500).json({
                error: 'Error al actualizar producto'
            });
        }

        return res.status(200).json({
            message: 'Producto actualizado',
            producto: data
        });
    } catch (error) {
        console.error('ERROR EN editar:', error);

        return res.status(500).json({
            error: error.message
        });
    }
};

export const eliminar = async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await eliminarProducto(id);

        if (error) {
            return res.status(500).json({
                error: 'Error al desactivar producto'
            });
        }

        if (!data || data.length === 0) {
            return res.status(404).json({
                error: 'Producto no encontrado'
            });
        }

        return res.status(200).json({
            message: 'Producto desactivado correctamente'
        });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

export const activar = async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await activarProducto(id);

        if (error) {
            return res.status(500).json({
                error: 'Error al activar producto'
            });
        }

        if (!data || data.length === 0) {
            return res.status(404).json({
                error: 'Producto no encontrado'
            });
        }

        return res.status(200).json({
            message: 'Producto activado correctamente'
        });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

export const eliminarDefinitivamente = async (req, res) => {
    try {
        const { id } = req.params;

        const { data, error } =
            await eliminarProductoDefinitivamente(id);

        if (error) {
            if (error.code === '23503') {
                return res.status(409).json({
                    error: 'No se puede eliminar definitivamente porque este producto está asociado a pedidos anteriores. Puedes desactivarlo para ocultarlo del menú.'
                });
            }

            return res.status(500).json({
                error: 'Error al eliminar definitivamente el producto'
            });
        }

        if (!data || data.length === 0) {
            return res.status(404).json({
                error: 'Producto no encontrado'
            });
        }

        return res.status(200).json({
            message: 'Producto eliminado definitivamente'
        });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};
