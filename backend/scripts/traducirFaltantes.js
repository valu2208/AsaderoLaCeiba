// Traduce los productos que tienen vacío el nombre en inglés o en portugués.
// Se ejecuta a mano, una sola vez:  node scripts/traducirFaltantes.js
// Necesita en el .env: SUPABASE_URL, SUPABASE_KEY y GROQ_API_KEY.
import 'dotenv/config';
import {
    obtenerTodosAdmin,
    actualizarProducto
} from '../models/producto.js';
import { traducirProducto } from '../utils/traducirProducto.js';

const { data: productos, error } = await obtenerTodosAdmin();

if (error) {
    console.error('No se pudieron leer los productos:', error.message);
    process.exit(1);
}

const pendientes = productos.filter((p) => !p.nombre_en || !p.nombre_pt);

console.log(`Productos: ${productos.length}. Sin traducir: ${pendientes.length}`);

let traducidos = 0;
const fallidos = [];

// Uno por uno, para no superar el límite de peticiones de Groq.
for (const p of pendientes) {
    const traduccion = await traducirProducto({
        nombre: p.nombre,
        descripcion: p.descripcion
    });

    if (!traduccion.nombre_en || !traduccion.nombre_pt) {
        fallidos.push(p.nombre);
        console.log(`✗ ${p.nombre} (Groq no devolvió traducción)`);
        continue;
    }

    const { error: errorActualizar } = await actualizarProducto(
        p.id,
        traduccion
    );

    if (errorActualizar) {
        fallidos.push(p.nombre);
        console.log(`✗ ${p.nombre} (${errorActualizar.message})`);
        continue;
    }

    traducidos++;
    console.log(
        `✓ ${p.nombre} → ${traduccion.nombre_en} / ${traduccion.nombre_pt}`
    );
}

console.log(`\nTraducidos: ${traducidos}. Fallidos: ${fallidos.length}`);
if (fallidos.length) console.log('Fallaron:', fallidos.join(', '));

process.exit(0);