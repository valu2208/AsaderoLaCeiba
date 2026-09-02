import 'dotenv/config';
export const enviarCodigoVerificacion = async (
    emailDestino,
    nombreDestino,
    codigo
) => {
    try {
        const respuesta = await fetch(
            'https://api.brevo.com/v3/smtp/email',
            {
                method: 'POST',

                headers: {
                    'accept': 'application/json',
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

                    subject:
                        'Código de verificación - Asadero La Ceiba',

                    htmlContent: `
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

                            <p>
                                Hola <strong>${nombreDestino}</strong>,
                            </p>

                            <p>
                                Gracias por registrarte en
                                Asadero La Ceiba.
                            </p>

                            <p>
                                Tu código de verificación es:
                            </p>

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
                                    ${codigo}
                                </span>

                            </div>

                            <p>
                                Este código vence en
                                <strong>10 minutos</strong>.
                            </p>

                            <p>
                                Asadero La Ceiba
                            </p>

                        </div>
                    `
                })
            }
        );

        const resultado = await respuesta.json();

        if (!respuesta.ok) {
            throw new Error(
                resultado.message ||
                resultado.code ||
                'Error enviando correo con Brevo'
            );
        }

        return {
            exito: true,
            result: resultado
        };

    } catch (error) { 
        return {
            exito: false,
            error
        };
    }
};