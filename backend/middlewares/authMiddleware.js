
import jwt from 'jsonwebtoken';

// Rol del usuario autenticado en minúsculas
const rolDe = (req) => String(req.usuario?.rol || '').toLowerCase();

// Verificar que existe un token válido
export const verificarToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({
            error: 'Token no proporcionado, por favor inicie sesión'
        });
    }

    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if (err) {
            return res.status(403).json({
                error: 'Token inválido o expirado'
            });
        }

        req.usuario = decoded;
        next();
    });
};

// Solo permite el acceso a administradores
export const verificarAdmin = (req, res, next) => {
    if (rolDe(req) !== 'admin') {
        return res.status(403).json({
            error: 'No tienes permisos de administrador'
        });
    }

    next();
};

// Impide que el administrador realice pedidos
export const verificarNoAdmin = (req, res, next) => {
    if (rolDe(req) === 'admin') {
        return res.status(403).json({
            error: 'Los administradores no pueden realizar pedidos.'
        });
    }

    next();
};

// Permite el acceso al propietario o a un administrador
export const verificarPropietarioOAdmin = (req, res, next) => {
    const esPropietario =
        String(req.usuario?.id) === String(req.params.id);

    if (!esPropietario && rolDe(req) !== 'admin') {
        return res.status(403).json({
            error: 'No tienes permiso para acceder a este usuario'
        });
    }

    next();
};

// Permite el acceso a los roles indicados
export const verificarRol = (...rolesPermitidos) => (req, res, next) => {
    if (!rolesPermitidos.includes(rolDe(req))) {
        return res.status(403).json({
            error: 'No tienes permisos para realizar esta acción'
        });
    }

    next();
};
