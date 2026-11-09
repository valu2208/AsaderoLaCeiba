import {
  obtenerInventario,
  actualizarStockBD,
  crearIngredienteBD,
  editarIngredienteBD,
  eliminarIngredienteBD
} from '../models/inventario.js';

const esEnteroValido = (valor) => Number.isInteger(valor) && valor >= 0;
const conBajo = (i) => ({ ...i, bajo: i.stock_actual <= i.stock_minimo });

// Lista de ingredientes; "bajo" indica que el stock llegó al mínimo
export const listarInventario = async (req, res) => {
  try {
    const { data, error } = await obtenerInventario();

    if (error) return res.status(500).json({ error: error.message });

    return res.status(200).json(data.map(conBajo));
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

// Ajustar la cantidad disponible de un ingrediente
export const actualizarStock = async (req, res) => {
  try {
    const stock = Number(req.body.stock_actual);

    if (!esEnteroValido(stock)) {
      return res.status(400).json({
        error: 'stock_actual debe ser un número entero mayor o igual a 0'
      });
    }

    const { data, error } = await actualizarStockBD(req.params.id, stock);

    if (error) return res.status(500).json({ error: error.message });
    if (!data) return res.status(404).json({ error: 'Ingrediente no encontrado' });

    return res.status(200).json({
      message: 'Stock actualizado',
      ingrediente: conBajo(data)
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

// Admin: crear un ingrediente nuevo
export const crearIngrediente = async (req, res) => {
  try {
    const ingrediente = String(req.body.ingrediente ?? '').trim();
    const unidad = String(req.body.unidad_medida ?? '').trim();
    const stockActual = Number(req.body.stock_actual ?? 0);
    const stockMinimo = Number(req.body.stock_minimo ?? 0);

    if (!ingrediente || !unidad) {
      return res.status(400).json({ error: 'El nombre y la unidad son obligatorios' });
    }
    if (!esEnteroValido(stockActual) || !esEnteroValido(stockMinimo)) {
      return res.status(400).json({
        error: 'El stock y el mínimo deben ser números enteros mayores o iguales a 0'
      });
    }

    const { data, error } = await crearIngredienteBD({
      ingrediente,
      unidad_medida: unidad,
      stock_actual: stockActual,
      stock_minimo: stockMinimo
    });

    if (error) return res.status(500).json({ error: error.message });

    return res.status(201).json({
      message: 'Ingrediente creado',
      ingrediente: conBajo(data)
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

// Admin: cambiar nombre, unidad o mínimo (el stock se ajusta con /:id/stock)
export const editarIngrediente = async (req, res) => {
  try {
    const cambios = {};

    if (req.body.ingrediente !== undefined) {
      const nombre = String(req.body.ingrediente).trim();
      if (!nombre) return res.status(400).json({ error: 'El nombre no puede estar vacío' });
      cambios.ingrediente = nombre;
    }

    if (req.body.unidad_medida !== undefined) {
      const unidad = String(req.body.unidad_medida).trim();
      if (!unidad) return res.status(400).json({ error: 'La unidad no puede estar vacía' });
      cambios.unidad_medida = unidad;
    }

    if (req.body.stock_minimo !== undefined) {
      const minimo = Number(req.body.stock_minimo);
      if (!esEnteroValido(minimo)) {
        return res.status(400).json({
          error: 'stock_minimo debe ser un número entero mayor o igual a 0'
        });
      }
      cambios.stock_minimo = minimo;
    }

    if (Object.keys(cambios).length === 0) {
      return res.status(400).json({ error: 'No hay nada que actualizar' });
    }

    const { data, error } = await editarIngredienteBD(req.params.id, cambios);

    if (error) return res.status(500).json({ error: error.message });
    if (!data) return res.status(404).json({ error: 'Ingrediente no encontrado' });

    return res.status(200).json({
      message: 'Ingrediente actualizado',
      ingrediente: conBajo(data)
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

// Admin: eliminar un ingrediente
export const eliminarIngrediente = async (req, res) => {
  try {
    const { data, error } = await eliminarIngredienteBD(req.params.id);

    if (error) return res.status(500).json({ error: error.message });
    if (!data) return res.status(404).json({ error: 'Ingrediente no encontrado' });

    return res.status(200).json({ message: 'Ingrediente eliminado' });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};