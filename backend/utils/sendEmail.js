import nodemailer from 'nodemailer';

const transporter = nodemailer.createTransport({
    host: process.env.SMTP_HOST,
    port: Number(process.env.SMTP_PORT) || 587,
    secure: Number(process.env.SMTP_PORT) === 465,
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
    }
});

export const enviarCodigoRecuperacion = async (
    email,
    nombre,
    codigo
) => {
    await transporter.sendMail({
        from: process.env.EMAIL_USER,
        to: email,
        subject: 'Código para recuperar tu contraseña - Asadero La Ceiba',
        html: `
            <h2>Recuperación de contraseña</h2>

            <p>Hola ${nombre},</p>

            <p>
                Recibimos una solicitud para recuperar la contraseña
                de tu cuenta en Asadero La Ceiba.
            </p>

            <p>Tu código de recuperación es:</p>

            <h1>${codigo}</h1>

            <p>
                Este código tiene una duración de 10 minutos.
            </p>

            <p>
                Si tú no solicitaste este cambio, puedes ignorar este correo.
            </p>

            <p>
                Asadero La Ceiba
            </p>
        `
    });
};