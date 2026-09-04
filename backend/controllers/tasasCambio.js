import { obtenerTasaCOPaUSD } from '../models/tasasCambio.js';

export const convertirCOPaUSD = async (req, res) => {
    try {
        const { pesos } = req.body;

        if (pesos === undefined || pesos === null) {
            return res.status(400).json({
                error: 'El valor en pesos colombianos es requerido'
            });
        }

        if (isNaN(pesos) || Number(pesos) < 0) {
            return res.status(400).json({
                error: 'El valor en pesos colombianos debe ser un número válido'
            });
        }

        const { tasa, error } = await obtenerTasaCOPaUSD();

        if (error) {
            return res.status(500).json({
                error: 'No se pudo obtener la tasa de cambio',
                detalle: error.message
            });
        }

        const pesosCOP = Number(pesos);
        const dolaresUSD = pesosCOP * tasa;

        return res.status(200).json({
            pesos_cop: pesosCOP,
            tasa_cop_usd: tasa,
            dolares_usd: Number(dolaresUSD.toFixed(2))
        });

    } catch (error) {
        console.error('ERROR EN convertirCOPaUSD:', error);

        return res.status(500).json({
            error: error.message
        });
    }
};