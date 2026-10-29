// Ayudas para el chat del asistente: qué datos ve la IA y cómo se limpia lo que responde

const DIAS = ['domingo', 'lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado'];

const SECCIONES = {
    desayuno: 'Desayuno',
    almuerzo: 'Almuerzo',
    gaseosas: 'Gaseosas',
    fin_de_semana: 'Fin de semana'
};

// Día de hoy en Colombia (el servidor de Render trabaja en hora UTC)
export const diaDeHoy = () => {
    const ahora = new Date(
        new Date().toLocaleString('en-US', { timeZone: 'America/Bogota' })
    );

    return DIAS[ahora.getDay()];
};

// Solo lo que un cliente debe saber: sin stock exacto, sin enlaces de imagen
export const productosParaCliente = (productos, hoy = diaDeHoy()) =>
    (productos || []).map((producto) => {
        const dias = Array.isArray(producto.dias) ? producto.dias : [];

        return {
            nombre: producto.nombre || '',
            descripcion: producto.descripcion || '',
            precio_cop: Number(producto.precio),
            seccion: producto.mas_pedido
                ? 'Lo más pedido'
                : SECCIONES[producto.categoria] || 'Otros',
            se_sirve_hoy: dias.length === 0 || dias.includes(hoy),
            disponible: producto.disponible !== false
        };
    });

// Quita markdown, enlaces y líneas de imagen/stock por si la IA los escribe igual
export const limpiarRespuesta = (texto) =>
    String(texto || '')
        .replace(/https?:\/\/\S+/gi, '')
        .replace(/\*|`|__/g, '')
        .replace(/^\s*#+\s*/gm, '')
        .replace(/^\s*[-•]\s+/gm, '')
        .replace(/^\s*(imagen|stock)[^\n]*$/gim, '')
        .replace(/[ \t]+\n/g, '\n')
        .replace(/\n{3,}/g, '\n\n')
        .trim();