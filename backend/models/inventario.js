import { supabase } from '../config/supabase.js';

export const obtenerInventario = async () => {
  const { data, error } = await supabase
    .from('inventario_ingredientes')
    .select('*')
    .order('ingrediente');

  return { data, error };
};

// Un ingrediente por su id (para saber cómo estaba antes de cambiarlo)
export const obtenerIngredienteBD = async (id) => {
  const { data, error } = await supabase
    .from('inventario_ingredientes')
    .select('*')
    .eq('id', id)
    .maybeSingle();

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

export const crearIngredienteBD = async (ingrediente) => {
  const { data, error } = await supabase
    .from('inventario_ingredientes')
    .insert(ingrediente)
    .select()
    .single();

  return { data, error };
};

export const editarIngredienteBD = async (id, cambios) => {
  const { data, error } = await supabase
    .from('inventario_ingredientes')
    .update(cambios)
    .eq('id', id)
    .select()
    .maybeSingle();

  return { data, error };
};

export const eliminarIngredienteBD = async (id) => {
  const { data, error } = await supabase
    .from('inventario_ingredientes')
    .delete()
    .eq('id', id)
    .select()
    .maybeSingle();

  return { data, error };
};