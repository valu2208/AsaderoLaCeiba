import { supabase } from '../config/supabase.js';

export const obtenerInventario = async () => {
  const { data, error } = await supabase
    .from('inventario_ingredientes')
    .select('*')
    .order('ingrediente');

  return { data, error };
};

export const actualizarStockBD = async (id, stock_actual) => {
  const { data, error } = await supabase
    .from('inventario_ingredientes')
    .update({ stock_actual })
    .eq('id', id)
    .select()
    .maybeSingle();

  return { data, error };
};