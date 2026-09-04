import express from 'express';
import { convertirCOPaUSD } from '../controllers/tasasCambio.js';

const tasasCambioRouter = express.Router();

tasasCambioRouter.post('/convertir', convertirCOPaUSD);

export default tasasCambioRouter;