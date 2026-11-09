// Colombia es UTC-5 todo el año (no tiene horario de verano)
const OFFSET_HORAS = -5;
const MS_HORA = 3600 * 1000;
const MESES = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];

// Fecha guardada en UTC -> misma fecha en hora de Colombia (se lee con getUTC*)
const aColombia = (fechaIso) => {
  const texto = String(fechaIso);
  const conZona = /(Z|[+-]\d\d:?\d\d)$/.test(texto) ? texto : `${texto}Z`;
  return new Date(new Date(conZona).getTime() + OFFSET_HORAS * MS_HORA);
};

// Rango en UTC del día, mes o año pedido. fechaTexto = 'YYYY-MM-DD' (por defecto, hoy).
export const calcularRango = (periodo, fechaTexto) => {
  const base = fechaTexto
    ? new Date(`${fechaTexto}T00:00:00Z`)
    : new Date(Date.now() + OFFSET_HORAS * MS_HORA);

  if (Number.isNaN(base.getTime())) return null;

  const y = base.getUTCFullYear();
  const m = base.getUTCMonth();
  const d = base.getUTCDate();
  let inicio;
  let fin;

  if (periodo === 'dia') {
    inicio = Date.UTC(y, m, d);
    fin = Date.UTC(y, m, d + 1);
  } else if (periodo === 'mes') {
    inicio = Date.UTC(y, m, 1);
    fin = Date.UTC(y, m + 1, 1);
  } else if (periodo === 'anio') {
    inicio = Date.UTC(y, 0, 1);
    fin = Date.UTC(y + 1, 0, 1);
  } else {
    return null;
  }

  const aUtc = (ms) => new Date(ms - OFFSET_HORAS * MS_HORA).toISOString();
  return { desde: aUtc(inicio), hasta: aUtc(fin), y, m };
};

// Barras vacías del gráfico: 24 horas, los días del mes o los 12 meses
const crearSerie = (periodo, rango) => {
  if (periodo === 'dia') {
    return Array.from({ length: 24 }, (_, h) => ({ etiqueta: `${h}`, total: 0 }));
  }
  if (periodo === 'mes') {
    const dias = new Date(Date.UTC(rango.y, rango.m + 1, 0)).getUTCDate();
    return Array.from({ length: dias }, (_, i) => ({ etiqueta: `${i + 1}`, total: 0 }));
  }
  return MESES.map((mes) => ({ etiqueta: mes, total: 0 }));
};

const posicionEnSerie = (periodo, fecha) => {
  if (periodo === 'dia') return fecha.getUTCHours();
  if (periodo === 'mes') return fecha.getUTCDate() - 1;
  return fecha.getUTCMonth();
};

export const armarReporte = (pedidos, periodo, rango, nombres) => {
  const serie = crearSerie(periodo, rango);
  const productos = new Map();
  let total = 0;

  for (const pedido of pedidos) {
    const valor = Number(pedido.total) || 0;
    total += valor;

    const indice = posicionEnSerie(periodo, aColombia(pedido.fecha_pedido));
    if (serie[indice]) serie[indice].total += valor;

    for (const detalle of pedido.detalle_pedido || []) {
      const actual = productos.get(detalle.producto_id) || { cantidad: 0, total: 0 };
      actual.cantidad += detalle.cantidad;
      actual.total += detalle.cantidad * (Number(detalle.precio_unitario) || 0);
      productos.set(detalle.producto_id, actual);
    }
  }

  const top = [...productos.entries()]
    .map(([id, datos]) => ({ nombre: nombres.get(id) || 'Plato', ...datos }))
    .sort((a, b) => b.cantidad - a.cantidad)
    .slice(0, 10);

  return {
    periodo,
    total,
    pedidos: pedidos.length,
    ticket_promedio: pedidos.length ? Math.round(total / pedidos.length) : 0,
    serie,
    top
  };
};