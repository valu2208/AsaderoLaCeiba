let tasaEnCache = null;
let ultimaConsulta = 0;
const VIGENCIA_MS = 60 * 60 * 1000; // 1 hora

export const obtenerTasaCOPaUSD = async () => {
    const ahora = Date.now();

    // Si hay una tasa reciente guardada, se usa sin consultar la API
    if (tasaEnCache && ahora - ultimaConsulta < VIGENCIA_MS) {
        return { tasa: tasaEnCache, error: null };
    }

    try {
        const apiKey = process.env.EXCHANGE_RATE_API_KEY;

        const respuesta = await fetch(
            `https://v6.exchangerate-api.com/v6/${apiKey}/latest/COP`
        );

        if (!respuesta.ok) {
            throw new Error('No se pudo consultar ExchangeRate-API');
        }

        const datos = await respuesta.json();

        if (datos.result !== 'success') {
            throw new Error('ExchangeRate-API devolvió un error');
        }

        const tasa = datos.conversion_rates.USD;

        tasaEnCache = tasa;
        ultimaConsulta = ahora;

        return { tasa, error: null };

    } catch (error) {
        console.error('ERROR EN obtenerTasaCOPaUSD:', error);

        // Si falla la consulta pero hay una tasa anterior, se usa esa
        if (tasaEnCache) {
            return { tasa: tasaEnCache, error: null };
        }

        return { tasa: null, error };
    }
};