import { guardarTokenBD, borrarTokenBD } from '../models/dispositivo.js';

export const registrarDispositivo = async (req, res) => {
    const token = String(req.body.token ?? '').trim();
    if (!token) return res.status(400).json({ error: 'El token es obligatorio' });

    const { error } = await guardarTokenBD(req.usuario.id, token);
    if (error) return res.status(500).json({ error: error.message });

    return res.status(200).json({ message: 'Dispositivo registrado' });
};

export const quitarDispositivo = async (req, res) => {
    const token = String(req.body.token ?? '').trim();
    if (!token) return res.status(400).json({ error: 'El token es obligatorio' });

    const { error } = await borrarTokenBD(req.usuario.id, token);
    if (error) return res.status(500).json({ error: error.message });

    return res.status(200).json({ message: 'Dispositivo eliminado' });
};