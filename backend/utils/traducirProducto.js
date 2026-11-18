
import Groq from 'groq-sdk';

export const traducirProducto = async ({ nombre, descripcion }) => {
    const traduccionesVacias = {
        nombre_en: '',
        description_en: '',
        nombre_pt: '',
        descripcion_pt: ''
    };

    try {
        if (!process.env.GROQ_API_KEY) {
            throw new Error('No está configurada GROQ_API_KEY');
        }

        const groq = new Groq({
            apiKey: process.env.GROQ_API_KEY
        });

        const respuesta = await groq.chat.completions.create({
            model: 'openai/gpt-oss-20b',
            messages: [
                {
                    role: 'system',
                    content: `
Eres un traductor especializado en gastronomía.

Traduce el nombre y la descripción de productos
de un restaurante desde español hacia inglés y portugués.

REGLAS:
- Conserva el significado original.
- No inventes ingredientes ni características.
- No agregues información que no esté en el texto.
- Conserva nombres culturales y propios de platos
  cuando su traducción pueda cambiar su identidad.
- Mantén nombres como "Asado Huilense" cuando corresponda.
- El nombre debe ser natural para el idioma de destino.
- Si la descripción está vacía, devuelve una cadena vacía.
- Devuelve únicamente un objeto JSON válido.

FORMATO OBLIGATORIO:
{
    "nombre_en": "",
    "description_en": "",
    "nombre_pt": "",
    "descripcion_pt": ""
}
`
                },
                {
                    role: 'user',
                    content: JSON.stringify({
                        nombre: nombre || '',
                        descripcion: descripcion || ''
                    })
                }
            ],
            response_format: {
                type: 'json_object'
            },
            temperature: 0,
            max_completion_tokens: 512,
            reasoning_effort: 'low',
            include_reasoning: false
        });

        const contenido = respuesta.choices?.[0]?.message?.content;

        if (!contenido) {
            throw new Error('Groq no devolvió las traducciones');
        }

        const resultado = JSON.parse(contenido);

        if (
            typeof resultado.nombre_en !== 'string' ||
            typeof resultado.description_en !== 'string' ||
            typeof resultado.nombre_pt !== 'string' ||
            typeof resultado.descripcion_pt !== 'string'
        ) {
            throw new Error('Groq devolvió traducciones incompletas');
        }

        return {
            nombre_en: resultado.nombre_en.trim(),
            description_en: resultado.description_en.trim(),
            nombre_pt: resultado.nombre_pt.trim(),
            descripcion_pt: resultado.descripcion_pt.trim()
        };
    } catch (error) {
        console.error('ERROR AL TRADUCIR PRODUCTO:', error);

        // El producto podrá guardarse en español aunque Groq falle.
        return traduccionesVacias;
    }
};
