import { supabase } from '../config/supabase.js';

// Crea un aviso para TODOS los usuarios de un rol (ej: 'mesero', 'cocinero')
export const avisarRol = async (
  rol,
  { pedido_id = null, tipo, titulo, mensaje }
) => {
  const { data: usuarios, error } = await supabase
    .from('usuarios')
    .select('id')
    .eq('rol', rol);

  if (error) {
    console.error(`Error buscando usuarios con rol ${rol}:`, error.message);
    return;
  }

  if (!usuarios || usuarios.length === 0) return;

  const filas = usuarios.map((u) => ({
    usuario_id: u.id,
    pedido_id,
    tipo,
    titulo,
    mensaje
  }));

  const { error: errorAviso } = await supabase
    .from('notificaciones')
    .insert(filas);

  if (errorAviso) {
    console.error(`Error creando avisos para ${rol}:`, errorAviso.message);
  }
};