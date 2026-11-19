import { initializeApp, cert, getApps } from 'firebase-admin/app';
import { getMessaging } from 'firebase-admin/messaging';

// Devuelve el servicio de mensajería, o null si no hay llave configurada.
// La llave va en la variable FIREBASE_SERVICE_ACCOUNT (el JSON completo).
export const obtenerMessaging = () => {
    const raw = process.env.FIREBASE_SERVICE_ACCOUNT;
    if (!raw) return null;

    if (getApps().length === 0) {
        initializeApp({ credential: cert(JSON.parse(raw)) });
    }
    return getMessaging();
};