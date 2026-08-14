import express from 'express';
import 'dotenv/config';
import authRoutes from './routes/auth.js';
import { conectaDB } from './config/supabase.js';
import userRoutes from './routes/user.js';
import productoRouter from './routes/producto.js';
import pedidoRouter from './routes/pedido.js';
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

app.use('/auth', authRoutes);
app.use('/usuario', userRoutes);
app.use('/productos', productoRouter);
app.use('/api', pedidoRouter);

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});