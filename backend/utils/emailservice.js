import 'dotenv/config';
import { plantillaCodigo } from './plantillaCorreo.js';

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
    return enviarCorreoBrevo({
        emailDestino,
        nombreDestino,
        asunto: 'Código de verificación - Asadero La Ceiba',
        contenido: plantillaCodigo({
            titulo: 'Verifica tu cuenta',
            nombre: nombreDestino,
            mensaje: 'Gracias por registrarte en Asadero La Ceiba. '
                + 'Usa el siguiente código para verificar tu correo:',
            codigo,
            aviso: 'Si no creaste esta cuenta, ignora este mensaje.'
        })
    });
};

// Enviar código para recuperar contraseña.
export const enviarCodigoRecuperacion = async (
    emailDestino,
    nombreDestino,
    codigo
) => {
    return enviarCorreoBrevo({
        emailDestino,
        nombreDestino,
        asunto: 'Código para recuperar tu contraseña - Asadero La Ceiba',
        contenido: plantillaCodigo({
            titulo: 'Recuperación de contraseña',
            nombre: nombreDestino,
            mensaje: 'Has solicitado restablecer tu contraseña. '
                + 'Utiliza el siguiente código de verificación:',
            codigo,
            aviso: 'Si no solicitaste este cambio, ignora este mensaje.'
        })
    });
};