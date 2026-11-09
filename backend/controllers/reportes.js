import { obtenerEntregadosBD, obtenerNombresProductosBD } from '../models/reportes.js';
import { calcularRango, armarReporte } from '../utils/reportes.js';

// GET /api/admin/reportes?periodo=dia|mes|anio&fecha=YYYY-MM-DD
export const reporteVentas = async (req, res) => {
  try {
    const periodo = req.query.periodo || 'dia';
    const rango = calcularRango(periodo, req.query.fecha);

    if (!rango) {
      return res.status(400).json({ error: 'Periodo o fecha no válidos' });
    }

    const { data: pedidos, error } = await obtenerEntregadosBD(rango.desde, rango.hasta);

    if (error) return res.status(500).json({ error: error.message });

    const ids = [
      ...new Set(
        pedidos.flatMap((p) => (p.detalle_pedido || []).map((d) => d.producto_id))
      )
    ];

    let nombres = new Map();
    if (ids.length > 0) {
      const { data } = await obtenerNombresProductosBD(ids);
      nombres = new Map((data || []).map((p) => [p.id, p.nombre]));
    }

    return res.status(200).json(armarReporte(pedidos, periodo, rango, nombres));
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};