import jwt from 'jsonwebtoken';

// Rol del usuario autenticado en minúsculas ('Admin' y 'admin' cuentan igual)
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

// Solo permite el acceso a usuarios con rol de administrador
export const verificarAdmin = (req, res, next) => {
    if (rolDe(req) !== 'admin') {
        return res.status(403).json({
            error: 'No tienes permisos de administrador'
        });
    }

    next();
};

// Permite el acceso al propio usuario (el id del token es el :id de la ruta) o a un admin
export const verificarPropietarioOAdmin = (req, res, next) => {
    const esPropietario = String(req.usuario?.id) === String(req.params.id);

    if (!esPropietario && rolDe(req) !== 'admin') {
        return res.status(403).json({
            error: 'No tienes permiso para acceder a este usuario'
        });
    }

    next();
};

// Permite el acceso a los roles indicados. Ej: verificarRol('cocinero', 'admin')
// (se usará en el paso 2 para cocina y pedidos)
export const verificarRol = (...rolesPermitidos) => (req, res, next) => {
    if (!rolesPermitidos.includes(rolDe(req))) {
        return res.status(403).json({
            error: 'No tienes permisos para realizar esta acción'
        });
    }

    next();
};