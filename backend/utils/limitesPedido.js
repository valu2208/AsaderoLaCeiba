export const MAX_POR_PLATO = 10;
export const MAX_PLATOS_PEDIDO = 30;
export const MAX_MESAS = 19;         // mesas que tiene el asadero
// Una mesa con pedido sin pagar se considera ocupada, pero solo por este tiempo.
// Así una mesa no se queda bloqueada para siempre si nadie cierra el pedido.
export const HORAS_MESA_OCUPADA = 4;

export const validarLimitesPedido = (productos) => {
  let totalPlatos = 0;

  for (const item of productos) {
    const cantidad = Number(item.cantidad);

    if (!Number.isInteger(cantidad) || cantidad < 1) {
      return 'La cantidad de cada plato debe ser un número entero mayor que cero.';
    }
    if (cantidad > MAX_POR_PLATO) {
      return `Máximo ${MAX_POR_PLATO} unidades de un mismo plato por pedido.`;
    }
    totalPlatos += cantidad;
  }

  if (totalPlatos > MAX_PLATOS_PEDIDO) {
    return `Máximo ${MAX_PLATOS_PEDIDO} platos por pedido.`;
  }
  return null;
};

export const mesaValida = (mesa) =>
  Number.isInteger(mesa) && mesa >= 1 && mesa <= MAX_MESAS;