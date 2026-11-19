import { avisarRol } from '../models/notificacion.js';

const estaBajo = (ingrediente) =>
    ingrediente.stock_actual <= ingrediente.stock_minimo;

// Avisa a los administradores cuando un ingrediente llega al mínimo o se agota.
// Solo avisa cuando el stock cruza el límite, para no repetir el aviso en cada ajuste.
// Si algo falla, solo lo registra: nunca debe impedir que se guarde el stock.
export const avisarSiBajoStock = async (antes, despues) => {
    try {
        if (!antes || !despues) return;

        const seAgoto = antes.stock_actual > 0 && despues.stock_actual === 0;
        const llegoAlMinimo = !estaBajo(antes) && estaBajo(despues);

        if (!seAgoto && !llegoAlMinimo) return;

        const nombre = despues.ingrediente;
        const agotado = despues.stock_actual === 0;

        const { error } = await avisarRol('admin', {
            tipo: 'stock_bajo',
            titulo: agotado ? `Se agotó: ${nombre}` : `Stock bajo: ${nombre}`,
            mensaje: agotado
                ? `Ya no queda ${nombre}. Hay que reponerlo.`
                : `Quedan ${despues.stock_actual} ${despues.unidad_medida} de ${nombre} (mínimo ${despues.stock_minimo}).`
        });

        if (error) {
            console.error('Error al avisar bajo stock:', error.message);
        }
    } catch (error) {
        console.error('Error al avisar bajo stock:', error.message);
    }
};