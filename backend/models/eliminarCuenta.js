import { supabase } from '../config/supabase.js';

// Tablas que guardan datos personales del usuario y se borran con su cuenta.
const TABLAS_PERSONALES = [
    'refresh_tokens',
    'dispositivos',
    'notificaciones',
    'mensajes_chat',
    'recovery_codes'
];

// Borra todo lo que depende del usuario y luego el usuario.
// Los pedidos NO se borran: quedan para las ventas y reportes del asadero,
// pero se desvinculan de la persona (usuario_id queda en null).
export const eliminarCuentaCompleta = async (id) => {
    for (const tabla of TABLAS_PERSONALES) {
        const { error } = await supabase
            .from(tabla)
            .delete()
            .eq('usuario_id', id);

        if (error) {
            return { error: { message: `${tabla}: ${error.message}` } };
        }
    }

    const { error: errorPedidos } = await supabase
        .from('pedidos')
        .update({ usuario_id: null })
        .eq('usuario_id', id);

    if (errorPedidos) {
        return { error: { message: `pedidos: ${errorPedidos.message}` } };
    }

    const { data, error } = await supabase
        .from('usuarios')
        .delete()
        .eq('id', id)
        .select('id')
        .maybeSingle();

    return { data, error };
};