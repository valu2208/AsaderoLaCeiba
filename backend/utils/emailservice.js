
import 'dotenv/config';

// Evitar que caracteres especiales dañen el HTML del correo.
const escaparHtml = (texto) => {
    return String(texto ?? '')
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
};

// Función general para enviar correos mediante Brevo.
const enviarCorreoBrevo = async ({
    emailDestino,
    nombreDestino,
    asunto,
    contenido
}) => {
    try {
        if (!process.env.BREVO_API_KEY || !process.env.EMAIL_USER) {
            throw new Error(
                'Falta configurar BREVO_API_KEY o EMAIL_USER en el archivo .env'
            );
        }

        const respuesta = await fetch(
            'https://api.brevo.com/v3/smtp/email',
            {
                method: 'POST',
                headers: {
                    accept: 'application/json',
                    'api-key': process.env.BREVO_API_KEY,
                    'content-type': 'application/json'
                },
                body: JSON.stringify({
                    sender: {
                        name: 'Asadero La Ceiba',
                        email: process.env.EMAIL_USER
                    },
                    to: [
                        {
                            email: emailDestino,
                            name: nombreDestino
                        }
                    ],
                    subject: asunto,
                    htmlContent: contenido
                })
            }
        );

        const textoRespuesta = await respuesta.text();

        let resultado = {};

        try {
            resultado = textoRespuesta
                ? JSON.parse(textoRespuesta)
                : {};
        } catch {
            resultado = {
                message: textoRespuesta
            };
        }

        if (!respuesta.ok) {
            throw new Error(
                resultado.message ||
                resultado.code ||
                `Brevo respondió con el estado ${respuesta.status}`
            );
        }

        return {
            exito: true,
            result: resultado
        };

    } catch (error) {
        console.error(
            'Error enviando correo con Brevo:',
            error.message
        );

        return {
            exito: false,
            error: error.message
        };
    }
};

// Enviar código para verificar correo.
export const enviarCodigoVerificacion = async (
    emailDestino,
    nombreDestino,
    codigo
) => {
    const nombre = escaparHtml(nombreDestino);
    const codigoSeguro = escaparHtml(codigo);

    return enviarCorreoBrevo({
        emailDestino,
        nombreDestino,
        asunto: 'Código de verificación - Asadero La Ceiba',
        contenido: `
            <div style="
                font-family: Arial, sans-serif;
                max-width: 500px;
                margin: 0 auto;
                padding: 24px;
                border: 1px solid #eeeeee;
                border-radius: 12px;
            ">
                <h2 style="text-align: center;">
                    Asadero La Ceiba
                </h2>

                <h3 style="text-align: center;">
                    Verifica tu cuenta
                </h3>

                <p>Hola <strong>${nombre}</strong>,</p>

                <p>
                    Gracias por registrarte en Asadero La Ceiba.
                </p>

                <p>Tu código de verificación es:</p>

                <div style="
                    text-align: center;
                    margin: 30px 0;
                ">
                    <span style="
                        font-size: 32px;
                        font-weight: bold;
                        letter-spacing: 8px;
                        color: #8B0000;
                    ">
                        ${codigoSeguro}
                    </span>
                </div>

                <p>
                    Este código vence en
                    <strong>10 minutos</strong>.
                </p>

                <p>Asadero La Ceiba</p>
            </div>
        `
    });
};

// Enviar código para recuperar contraseña.
export const enviarCodigoRecuperacion = async (
    emailDestino,
    nombreDestino,
    codigo
) => {
    const nombre = escaparHtml(nombreDestino);
    const codigoSeguro = escaparHtml(codigo);

    return enviarCorreoBrevo({
        emailDestino,
        nombreDestino,
        asunto: 'Código para recuperar tu contraseña - Asadero La Ceiba',
        contenido: `
            <div style="
                font-family: Arial, sans-serif;
                max-width: 500px;
                margin: 0 auto;
                padding: 24px;
                border: 1px solid #eeeeee;
                border-radius: 12px;
            ">
                <h2 style="text-align: center;">
                    Asadero La Ceiba
                </h2>

                <h3 style="text-align: center;">
                    Recuperación de contraseña
                </h3>

                <p>Hola <strong>${nombre}</strong>,</p>

                <p>
                    Recibimos una solicitud para recuperar la contraseña
                    de tu cuenta en Asadero La Ceiba.
                </p>

                <p>Tu código de recuperación es:</p>

                <div style="
                    text-align: center;
                    margin: 30px 0;
                ">
                    <span style="
                        font-size: 32px;
                        font-weight: bold;
                        letter-spacing: 8px;
                        color: #8B0000;
                    ">
                        ${codigoSeguro}
                    </span>
                </div>

                <p>
                    Este código tiene una duración de
                    <strong>10 minutos</strong>.
                </p>

                <p>
                    Si tú no solicitaste este cambio,
                    puedes ignorar este correo.
                </p>

                <p>Asadero La Ceiba</p>
            </div>
        `
    });
};
