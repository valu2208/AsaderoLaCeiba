import express from 'express';
import 'dotenv/config';
import { conectaDB } from './config/supabase.js';
import productoRouter from './routes/producto.js';
import pedidoRouter from './routes/pedido.js';
import userRouter from './routes/user.js';
import authRouter from './routes/auth.js';
import cors from 'cors';

conectaDB();

const app = express();

app.use(express.json());
app.use(cors());

app.get('/', (req, res) => {
    res.json({
        Mensaje: "Bienvenido al Asadero LA CEIBA",
        Estado: "En linea",
        Version: "1.0.0"
    });
});

app.use('/productos', productoRouter);
app.use('/api', pedidoRouter);
app.use('/usuarios', userRouter);
app.use('/auth', authRouter);

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});