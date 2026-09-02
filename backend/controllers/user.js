import bcrypt from 'bcrypt';
import { enviarCodigoVerificacion } from '../utils/emailservice.js';

import {
    crearUsuario,
    obtenerTodosUsuarios,
    obtenerUsuarioPorId,
    obtenerUsuarioPorEmail,
    actualizarUsuario,
    eliminarUsuario as eliminarUsuarioBD,
    obtenerUsuarioPorCodigoVerificacion,
    verificarUsuario,
    actualizarCodigoVerificacion
} from '../models/user.js';

// Registrar usuario
export const registrarUsuario = async (req, res) => {
    try {
        const {
            nombre,
            email,
            telefono,
            password,
            rol
        } = req.body;

        if (!nombre || !email || !telefono || !password) {
            return res.status(400).json({
                error: 'Nombre, email, teléfono y contraseña son requeridos'
            });
        }

        const passwordHash = await bcrypt.hash(password, 10);

        const codigoVerificacion = Math.floor(
            100000 + Math.random() * 900000
        ).toString();

        const codigoVerificacionExpiracion = new Date(
            Date.now() + 10 * 60 * 1000
        ).toISOString();

        const { data, error } = await crearUsuario({
            nombre,
            email,
            telefono,
            password: passwordHash,
            rol: 'usuario',
            isVerified: false,
            codigoVerificacion,
            codigoVerificacionExpiracion
        });

        if (error) {
            return res.status(500).json({
                error: error.message
            });
        }

        await enviarCodigoVerificacion(
            email,
            nombre,
            codigoVerificacion
        );

        return res.status(201).json({
            message: 'Usuario creado exitosamente. Se envió un código de verificación al correo.',
            usuario: {
                id: data.id,
                nombre: data.nombre,
                email: data.email,
                telefono: data.telefono,
                rol: data.rol,
                isVerified: data.isVerified,
                creado_en: data.creado_en
            }
        });

    } catch (error) {
        console.error('ERROR EN registrarUsuario:', error);

        return res.status(500).json({
            error: error.message
        });
    }
};

// Verificar correo electrónico
export const verificarCorreo = async (req, res) => {
    try {
        const { email, codigo } = req.body;

        if (!email || !codigo) {
            return res.status(400).json({
                error: 'Email y código son requeridos'
            });
        }

        const { data: usuario, error } =
            await obtenerUsuarioPorCodigoVerificacion(
                email,
                codigo
            );

        if (error) {
            return res.status(500).json({
                error: error.message
            });
        }

        if (!usuario) {
            return res.status(400).json({
                error: 'Código incorrecto, expirado o cuenta ya verificada'
            });
        }

        const {
            data,
            error: errorVerificacion
        } = await verificarUsuario(usuario.id);

        if (errorVerificacion) {
            return res.status(500).json({
                error: errorVerificacion.message
            });
        }

        return res.status(200).json({
            message: 'Correo verificado correctamente',
            usuario: data
        });

    } catch (error) {
        console.error('ERROR EN verificarCorreo:', error);

        return res.status(500).json({
            error: error.message
        });
    }
};

// Listar todos los usuarios
export const listarUsuarios = async (req, res) => {
    try {
        const { data, error } = await obtenerTodosUsuarios();

        if (error) {
            return res.status(500).json({
                error: error.message
            });
        }

        return res.status(200).json(data);

    } catch (error) {
        console.error('ERROR EN listarUsuarios:', error);

        return res.status(500).json({
            error: error.message
        });
    }
};

// Obtener usuario por ID
export const obtenerUsuario = async (req, res) => {
    try {
        const { id } = req.params;

        const { data, error } = await obtenerUsuarioPorId(id);

        if (error) {
            return res.status(404).json({
                error: 'Usuario no encontrado'
            });
        }

        return res.status(200).json(data);

    } catch (error) {
        console.error('ERROR EN obtenerUsuario:', error);

        return res.status(500).json({
            error: error.message
        });
    }
};

// Editar usuario
export const editarUsuario = async (req, res) => {
    try {
        const { id } = req.params;

        const {
            nombre,
            email,
            telefono,
            password,
            rol
        } = req.body;

        const datosActualizados = {};

        if (nombre) datosActualizados.nombre = nombre;
        if (email) datosActualizados.email = email;
        if (telefono) datosActualizados.telefono = telefono;
        if (rol) datosActualizados.rol = rol;

        if (password) {
            datosActualizados.password =
                await bcrypt.hash(password, 10);
        }

        const {
            data,
            error
        } = await actualizarUsuario(
            id,
            datosActualizados
        );

        if (error) {
            return res.status(500).json({
                error: error.message
            });
        }

        return res.status(200).json({
            message: 'Usuario actualizado correctamente',
            usuario: data
        });

    } catch (error) {
        console.error('ERROR EN editarUsuario:', error);

        return res.status(500).json({
            error: error.message
        });
    }
};

// Eliminar usuario
export const eliminarUsuario = async (req, res) => {
    try {
        const { id } = req.params;

        const {
            data,
            error
        } = await eliminarUsuarioBD(id);

        if (error) {
            return res.status(500).json({
                error: error.message
            });
        }

        return res.status(200).json({
            message: 'Usuario eliminado correctamente',
            usuario: data
        });

    } catch (error) {
        console.error('ERROR EN eliminarUsuario:', error);

        return res.status(500).json({
            error: error.message
        });
    }
};

// Reenviar código de verificación
export const reenviarCodigo = async (req, res) => {
    try {
        const { email } = req.body;

        if (!email) {
            return res.status(400).json({
                error: 'El email es requerido'
            });
        }

        const { data: usuario, error: errorUsuario } =
            await obtenerUsuarioPorEmail(email);

        if (errorUsuario || !usuario) {
            return res.status(404).json({
                error: 'Usuario no encontrado'
            });
        }

        if (usuario.isVerified) {
            return res.status(400).json({
                error: 'La cuenta ya está verificada'
            });
        }

        const codigoVerificacion = Math.floor(
            100000 + Math.random() * 900000
        ).toString();

        const codigoVerificacionExpiracion = new Date(
            Date.now() + 10 * 60 * 1000
        ).toISOString();

        const { error: errorActualizacion } =
            await actualizarCodigoVerificacion(
                email,
                codigoVerificacion,
                codigoVerificacionExpiracion
            );

        if (errorActualizacion) {
            return res.status(500).json({
                error: errorActualizacion.message
            });
        }

        const resultadoCorreo = await enviarCodigoVerificacion(
            usuario.email,
            usuario.nombre,
            codigoVerificacion
        );

        if (!resultadoCorreo.exito) {
            return res.status(500).json({
                error: 'No se pudo enviar el código de verificación'
            });
        }

        return res.status(200).json({
            message: 'Código de verificación reenviado correctamente'
        });

    } catch (error) {
        console.error('ERROR EN reenviarCodigo:', error);

        return res.status(500).json({
            error: error.message
        });
    }
};