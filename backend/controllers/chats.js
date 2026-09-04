import { randomUUID } from 'crypto';
import Groq from 'groq-sdk';

import { obtenerTodos } from '../models/producto.js';

import {
    guardarMensaje,
    obtenerMensajesPorSesion
} from '../models/chats.js';

import { obtenerTasaCOPaUSD } from '../models/tasasCambio.js';

const groq = new Groq({
    apiKey: process.env.GROQ_API_KEY
});

export const enviarMensaje = async (req, res) => {
    try {
        const {
            sesion_id: sesionRecibida,
            usuario_id,
            mensaje
        } = req.body;

        const sesion_id = sesionRecibida || randomUUID();

        // Validar mensaje
        if (!mensaje || !mensaje.trim()) {
            return res.status(400).json({
                error: 'El mensaje es requerido'
            });
        }

        const mensajeLimpio = mensaje.trim();

        const {
            data: productos,
            error: errorProductos
        } = await obtenerTodos();

        if (errorProductos) {
            return res.status(500).json({
                error: 'No se pudieron obtener los productos del Asadero',
                detalle: errorProductos.message
            });
        }
        const {
            data: historial,
            error: errorHistorial
        } = await obtenerMensajesPorSesion(sesion_id);

        if (errorHistorial) {
            return res.status(500).json({
                error: 'No se pudo obtener el historial del chat',
                detalle: errorHistorial.message
            });
        }

        const productosParaGroq = (productos || []).map((producto) => ({
            id: String(producto.id),
            nombre: producto.nombre || '',
            nombre_en: producto.nombre_en || '',
            descripcion: producto.descripcion || '',
            presentacion: producto.presentacion || '',
            precio: producto.precio,
            stock: producto.stock,
            categoria: producto.categoria || ''
        }));

        const analisis = await groq.chat.completions.create({
            model: 'openai/gpt-oss-20b',

            messages: [
                {
                    role: 'system',
                    content: `
Eres el sistema encargado de interpretar mensajes de clientes
del Asadero La Ceiba.

Debes identificar:

1. Si el cliente habla de dólares o USD.
2. Si quiere conocer un precio.
3. Qué producto está mencionando.
4. El ID del producto mencionado.

Debes entender:

- lenguaje natural
- frases completas
- frases cortas
- abreviaciones
- diminutivos
- errores de escritura
- mensajes escritos informalmente

FORMAS DE REFERIRSE A POLLO ASADO:

- pollo
- pollito
- pollo asado
- un pollo
- medio pollo
- medio de pollo
- cuarto de pollo
- un cuarto de pollo
- pollo completo

Estas expresiones pueden referirse a "Pollo asado"
SOLO si ese producto existe en la lista.

FORMAS DE REFERIRSE A DÓLARES:

- dolar
- dólar
- dólares
- dolares
- usd
- USD
- dls
- pago en dólares
- pagar en dólares
- pago en usd
- pagar en usd
- voy a pagar en dólares
- voy a pagar en dolares

IMPORTANTE:

- No inventes productos.
- No inventes IDs.
- Solo puedes seleccionar productos de la lista.
- "desayunos", "almuerzos", "cena", "fin de semana",
  "platos a la carta" y términos generales NO deben
  convertirse automáticamente en "Pollo asado".
- Solo identifica un producto cuando exista una relación clara.
- Si el cliente menciona un producto de manera informal,
  intenta relacionarlo con un producto real de la lista.
- Si no puedes identificar el producto, deja los campos
  del producto vacíos.

PRODUCTOS DEL ASADERO:

${JSON.stringify(productosParaGroq, null, 2)}

Devuelve ÚNICAMENTE JSON válido.

Formato:

{
    "habla_de_dolares": true,
    "quiere_precio": true,
    "producto_mencionado": "Pollo asado",
    "id_producto": "1"
}

Si no se identifica producto:

{
    "habla_de_dolares": true,
    "quiere_precio": true,
    "producto_mencionado": "",
    "id_producto": ""
}
                    `
                },
                {
                    role: 'user',
                    content: mensajeLimpio
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
        const contenidoAnalisis =
            analisis.choices?.[0]?.message?.content;

        if (!contenidoAnalisis) {
            console.error(
                'GROQ NO DEVOLVIÓ CONTENIDO EN EL ANÁLISIS:',
                JSON.stringify(analisis)
            );

            return res.status(500).json({
                error: 'No se pudo analizar el mensaje'
            });
        }

        let resultadoAnalisis;

        try {
            resultadoAnalisis = JSON.parse(contenidoAnalisis);
        } catch (error) {
            console.error(
                'ERROR AL CONVERTIR EL ANÁLISIS A JSON:',
                contenidoAnalisis
            );

            return res.status(500).json({
                error: 'Groq devolvió un formato no válido'
            });
        }

        let productoSeleccionado = null;

        if (resultadoAnalisis.id_producto) {
            productoSeleccionado = (productos || []).find(
                (producto) =>
                    String(producto.id) ===
                    String(resultadoAnalisis.id_producto)
            );
        }
        if (
            !productoSeleccionado &&
            resultadoAnalisis.producto_mencionado
        ) {
            const productoBuscado =
                resultadoAnalisis.producto_mencionado
                    .toLowerCase()
                    .trim();

            productoSeleccionado = (productos || []).find((producto) => {
                const nombre =
                    producto.nombre?.toLowerCase() || '';

                const nombreEn =
                    producto.nombre_en?.toLowerCase() || '';

                return (
                    nombre === productoBuscado ||
                    nombre.includes(productoBuscado) ||
                    productoBuscado.includes(nombre) ||
                    nombreEn === productoBuscado ||
                    nombreEn.includes(productoBuscado) ||
                    productoBuscado.includes(nombreEn)
                );
            });
        }
        // CONVERSIÓN COP → USD
        let contextoConversion = '';

        if (
            resultadoAnalisis.habla_de_dolares &&
            resultadoAnalisis.quiere_precio &&
            productoSeleccionado
        ) {
            const precioCOP = Number(
                productoSeleccionado.precio
            );

            if (isNaN(precioCOP)) {
                return res.status(500).json({
                    error: 'El precio del producto no es válido'
                });
            }

            const {
                tasa,
                error: errorTasa
            } = await obtenerTasaCOPaUSD();

            if (errorTasa || !tasa) {
                return res.status(500).json({
                    error: 'No se pudo obtener la tasa de cambio',
                    detalle: errorTasa?.message
                });
            }

            const precioUSD =
                precioCOP * Number(tasa);

            contextoConversion = `
DATOS DE CONVERSIÓN CALCULADOS POR EL SISTEMA:

Producto:
${productoSeleccionado.nombre}

Precio real:
$${precioCOP.toLocaleString('es-CO')} COP

Tasa actual:
${tasa}

Equivalente:
$${precioUSD.toFixed(2)} USD

IMPORTANTE:
Utiliza exactamente estos valores.
No inventes otra tasa.
No vuelvas a calcular.
`;
        }

        const mensajesHistorial = (historial || []).map((item) => ({
            role: item.emisor === 'usuario'
                ? 'user'
                : 'assistant',
            content: item.mensaje
        }));

        // Agregar mensaje actual
        mensajesHistorial.push({
            role: 'user',
            content: mensajeLimpio
        });

        const contextoProductos = (productos || [])
            .map((producto) => JSON.stringify(producto))
            .join('\n');

        const completion = await groq.chat.completions.create({
            model: 'openai/gpt-oss-20b',

            messages: [
                {
                    role: 'system',
                    content: `
Eres el asistente virtual del Asadero La Ceiba.

Ayuda a los clientes de forma amable, natural y clara.

REGLAS:

- Entiende lenguaje natural.
- Entiende frases completas.
- Entiende frases cortas.
- Entiende abreviaciones.
- Entiende diminutivos.
- Entiende errores comunes de escritura.
- No inventes productos.
- No inventes precios.
- No inventes disponibilidad.
- No inventes tasas de cambio.
- Utiliza solamente la información proporcionada.
- No muestres el sesion_id.
- No menciones Groq.
- No menciones APIs.
- No menciones Supabase.
- No hables de programación.
- No salgas del tema del Asadero La Ceiba.

CUANDO EL CLIENTE PREGUNTE POR UN PRODUCTO:

Utiliza el producto real encontrado en la información
del Asadero.

CUANDO EL CLIENTE QUIERA PAGAR O CONSULTAR EL PRECIO
EN DÓLARES:

Muestra primero el precio en pesos colombianos
y después el equivalente en dólares.

Utiliza EXACTAMENTE la conversión proporcionada
por el sistema.

NO recalcules la conversión.

NO inventes una tasa.

SI EL CLIENTE HABLA DE DÓLARES PERO NO MENCIONA
UN PRODUCTO:

Pregúntale qué producto desea consultar.

PRODUCTOS DEL ASADERO:

${contextoProductos}

${contextoConversion}
                    `
                },

                ...mensajesHistorial
            ],

            temperature: 0.5,
            max_completion_tokens: 1024,
            reasoning_effort: 'low',
            include_reasoning: false
        });
        const respuesta =
            completion.choices?.[0]?.message?.content;

        if (!respuesta) {
            console.error(
                'GROQ NO DEVOLVIÓ CONTENIDO EN LA RESPUESTA FINAL:',
                JSON.stringify(completion)
            );

            return res.status(500).json({
                error: 'No se pudo generar la respuesta del chatbot'
            });
        }
        //guardar pregunts del usuario

        const {
            error: errorUsuario
        } = await guardarMensaje({
            sesion_id,
            usuario_id: usuario_id || null,
            emisor: 'usuario',
            mensaje: mensajeLimpio
        });

        if (errorUsuario) {
            return res.status(500).json({
                error: 'No se pudo guardar el mensaje del usuario',
                detalle: errorUsuario.message
            });
        }

        const {
            error: errorBot
        } = await guardarMensaje({
            sesion_id,
            usuario_id: usuario_id || null,
            emisor: 'bot',
            mensaje: respuesta
        });

        if (errorBot) {
            return res.status(500).json({
                error: 'La respuesta fue generada pero no se pudo guardar',
                detalle: errorBot.message,
                respuesta
            });
        }

        return res.status(200).json({
            mensaje: respuesta,
            sesion_id
        });

    } catch (error) {
        console.error(
            'ERROR EN enviarMensaje:',
            error
        );

        return res.status(500).json({
            error: error.message
        });
    }
};