import nodemailer from 'nodemailer';
import { plantillaCodigo } from './plantillaCorreo.js';

const transporter = nodemailer.createTransport({
    host: process.env.SMTP_HOST,
    port: Number(process.env.SMTP_PORT) || 587,
    secure: Number(process.env.SMTP_PORT) === 465,
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
    }
});

// Enviar código para recuperar contraseña
export const enviarCodigoRecuperacion = async (
    email,
    nombre,
    codigo
) => {
    await transporter.sendMail({
        from: process.env.EMAIL_USER,
        to: email,
        subject: 'Código para recuperar tu contraseña - Asadero La Ceiba',
        html: plantillaCodigo({
            titulo: 'Recuperación de contraseña',
            nombre,
            mensaje: 'Has solicitado restablecer tu contraseña. '
                + 'Utiliza el siguiente código de verificación:',
            codigo,
            aviso: 'Si no solicitaste este cambio, ignora este mensaje.'
        })
    });
};

// Enviar código para verificar correo
export const enviarCodigoVerificacion = async (
    email,
    nombre,
    codigo
) => {
    await transporter.sendMail({
        from: process.env.EMAIL_USER,
        to: email,
        subject: 'Verifica tu correo - Asadero La Ceiba',
        html: plantillaCodigo({
            titulo: 'Verifica tu cuenta',
            nombre,
            mensaje: 'Gracias por registrarte en Asadero La Ceiba. '
                + 'Usa el siguiente código para verificar tu correo:',
            codigo,
            aviso: 'Si no creaste esta cuenta, ignora este mensaje.'
        })
    });
};