import { obtenerMessaging } from '../config/firebase.js';
import { tokensDeUsuarios, borrarTokensInvalidos } from '../models/dispositivo.js';

const TOKEN_MUERTO = [
    'messaging/registration-token-not-registered',
    'messaging/invalid-registration-token'
];

// Envía una notificación push a los celulares de los usuarios indicados.
// Nunca lanza error: si algo falla solo lo registra, para no tumbar el flujo del pedido.
export const enviarPush = async (usuarioIds, { tipo, titulo, mensaje, pedido_id = null }) => {
    try {
        if (tipo === 'bienvenida') return;

        const messaging = obtenerMessaging();
        if (!messaging) return;

        const { data, error } = await tokensDeUsuarios(usuarioIds);
        if (error || !data || data.length === 0) return;

        const tokens = [...new Set(data.map((d) => d.token))];

        const respuesta = await messaging.sendEachForMulticast({
            tokens,
            notification: { title: titulo, body: mensaje },
            data: {
                tipo: String(tipo ?? ''),
                pedido_id: pedido_id ? String(pedido_id) : ''
            },
            android: {
                priority: 'high',
                notification: { channelId: 'high_importance_channel' }
            }
        });

        const muertos = [];
        respuesta.responses.forEach((r, i) => {
            if (!r.success && TOKEN_MUERTO.includes(r.error?.code)) muertos.push(tokens[i]);
        });
        await borrarTokensInvalidos(muertos);
    } catch (error) {
        console.error('Error al enviar push:', error.message);
    }
};