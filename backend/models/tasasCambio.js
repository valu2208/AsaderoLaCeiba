export const obtenerTasaCOPaUSD = async () => {
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

        return {
            tasa,
            error: null
        };

    } catch (error) {
        console.error('ERROR EN obtenerTasaCOPaUSD:', error);

        return {
            tasa: null,
            error
        };
    }
};