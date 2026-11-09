import express from 'express';
import 'dotenv/config';
import { conectaDB } from './config/supabase.js';
import productoRouter from './routes/producto.js';
import pedidoRouter from './routes/pedido.js';
import userRouter from './routes/user.js';
import authRouter from './routes/auth.js';
import recuperarRouter from './routes/recuperar.js';
import cocinaRouter from './routes/cocina.js';
import chatRouter from './routes/chats.js';
import tasasCambioRouter from './routes/tasasCambio.js';
import notificacionRouter from './routes/notificacion.js';
import meseroRouter from './routes/mesero.js';
import inventarioRouter from './routes/inventario.js';
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

//Montando las rutas Apis
app.get('/health', (req, res) => {
    res.status(200).send('OK');
});

// Rutas de productos, pedidos, usuarios, autenticación, recuperación de contraseña, cocina, chat, tasas de cambio, notificaciones, mesero e inventario
app.use('/productos', productoRouter);

// Rutas de pedidos, usuarios, autenticación, recuperación de contraseña, cocina, chat, tasas de cambio, notificaciones, mesero e inventario
app.use('/api', pedidoRouter);
app.use('/usuarios', userRouter);
app.use('/auth', authRouter);
app.use('/recuperar', recuperarRouter);
app.use('/cocina', cocinaRouter);
app.use('/chat', chatRouter);
app.use('/tasas-cambio', tasasCambioRouter);
app.use('/notificaciones', notificacionRouter);

// Rutas de mesero e inventario
app.use('/mesero', meseroRouter);
// Rutas de inventario
app.use('/inventario', inventarioRouter);
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});