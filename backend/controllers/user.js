import bcrypt from 'bcrypt';
import {
    crearUsuario,
    obtenerTodosUsuarios,
    obtenerUsuarioPorId,
    actualizarUsuario,
    eliminarUsuario as eliminarUsuarioBD
} from '../models/user.js';

// Crear usuario
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

        const { data, error } = await crearUsuario({
            nombre,
            email,
            telefono,
            password: passwordHash,
            rol: rol || 'usuario'
        });

        if (error) {
            return res.status(500).json({
                error: error.message
            });
        }

        return res.status(201).json({
    message: 'Usuario creado exitosamente',
    usuario: {
        id: data.id,
        nombre: data.nombre,
        email: data.email,
        telefono: data.telefono,
        rol: data.rol,
        creado_en: data.creado_en
    }
});

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

// Obtener todos los usuarios
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

        if (error || !data) {
            return res.status(404).json({
                error: 'Usuario no encontrado'
            });
        }

        return res.status(200).json(data);

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

// Actualizar usuario
export const editarUsuario = async (req, res) => {
    try {
        const { id } = req.params;

        const datosActualizar = {
            nombre: req.body.nombre,
            email: req.body.email,
            telefono: req.body.telefono
        };

        if (req.body.password) {
            datosActualizar.password = await bcrypt.hash(
                req.body.password,
                10
            );
        }

        if (req.body.rol) {
            datosActualizar.rol = req.body.rol;
        }

        const { data, error } = await actualizarUsuario(
            id,
            datosActualizar
        );

        if (error) {
            return res.status(500).json({
                error: error.message
            });
        }

        return res.status(200).json({
            message: 'Usuario actualizado',
            usuario: data
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

// Eliminar usuario
export const eliminarUsuario = async (req, res) => {
    try {
        const { id } = req.params;

        const { data, error } = await eliminarUsuarioBD(id);

        if (error) {
            return res.status(500).json({
                error: error.message
            });
        }

        return res.status(200).json({
            message: 'Usuario eliminado',
            usuario: data
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};