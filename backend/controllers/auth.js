
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { obtenerUsuarioPorEmail } from '../models/user.js';

export const iniciarSesion = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({
                error: 'Email y contraseña son requeridos'
            });
        }

        const { data: usuario, error } = await obtenerUsuarioPorEmail(email);

        if (error || !usuario) {
            return res.status(401).json({
                error: 'Email o contraseña incorrectos'
            });
        }

        const passwordValida = await bcrypt.compare(
            password,
            usuario.password
        );

        if (!passwordValida) {
            return res.status(401).json({
                error: 'Email o contraseña incorrectos'
            });
        }

        const token = jwt.sign(
            {
                id: usuario.id,
                email: usuario.email,
                rol: usuario.rol
            },
            process.env.JWT_SECRET,
            {
                expiresIn: '2h'
            }
        );

        return res.status(200).json({
            message: 'Inicio de sesión exitoso',
            token,
            usuario: {
                id: usuario.id,
                nombre: usuario.nombre,
                email: usuario.email,
                telefono: usuario.telefono,
                rol: usuario.rol
            }
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};
//el trabajo es autenticado 
//controlador para autenticacion e inciio de sesion de los usuarios 

