import { obtenerInventario, actualizarStockBD } from '../models/inventario.js';

// Lista de ingredientes; "bajo" indica que el stock llegó al mínimo
export const listarInventario = async (req, res) => {
  try {
    const { data, error } = await obtenerInventario();

    if (error) return res.status(500).json({ error: error.message });

    return res.status(200).json(
      data.map((i) => ({ ...i, bajo: i.stock_actual <= i.stock_minimo }))
    );
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

// Ajustar la cantidad disponible de un ingrediente
export const actualizarStock = async (req, res) => {
  try {
    const stock = Number(req.body.stock_actual);

    if (!Number.isInteger(stock) || stock < 0) {
      return res.status(400).json({
        error: 'stock_actual debe ser un número entero mayor o igual a 0'
      });
    }

    const { data, error } = await actualizarStockBD(req.params.id, stock);

    if (error) return res.status(500).json({ error: error.message });
    if (!data) return res.status(404).json({ error: 'Ingrediente no encontrado' });

    return res.status(200).json({
      message: 'Stock actualizado',
      ingrediente: { ...data, bajo: data.stock_actual <= data.stock_minimo }
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};