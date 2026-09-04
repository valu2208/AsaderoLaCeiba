import express from 'express';
import { enviarMensaje } from '../controllers/chats.js';

const chatRouter = express.Router();

chatRouter.post('/mensaje', enviarMensaje);

export default chatRouter;