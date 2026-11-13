
import express from 'express';

import { enviarMensaje } from '../controllers/chats.js';

import {
    listarHistorialChat,
    obtenerHistorialChat,
    eliminarHistorialChat
} from '../controllers/historialChat.js';

import { verificarToken } from '../middlewares/authMiddleware.js';

const chatRouter = express.Router();

// Enviar mensajes a la IA.
chatRouter.post('/mensaje', verificarToken, enviarMensaje);

// Listar conversaciones del usuario.
chatRouter.get('/historial', verificarToken, listarHistorialChat);

// Consultar mensajes de una conversación.
chatRouter.get('/historial/:sesionId', verificarToken, obtenerHistorialChat);

// Eliminar una conversación del usuario.
chatRouter.delete('/historial/:sesionId', verificarToken, eliminarHistorialChat);

export default chatRouter;
