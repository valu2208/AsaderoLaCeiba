double _numero(dynamic valor) => (valor as num?)?.toDouble() ?? 0;

// Una barra del gráfico (una hora, un día o un mes)
class PuntoSerie {
  final String etiqueta;
  final double total;

  const PuntoSerie({required this.etiqueta, required this.total});

  factory PuntoSerie.fromJson(Map<String, dynamic> json) {
    return PuntoSerie(
      etiqueta: json['etiqueta']?.toString() ?? '',
      total: _numero(json['total']),
    );
  }
}

// Un plato de la lista de más vendidos
class PlatoVendido {
  final String nombre;
  final int cantidad;
  final double total;

  const PlatoVendido({required this.nombre, required this.cantidad, required this.total});

  factory PlatoVendido.fromJson(Map<String, dynamic> json) {
    return PlatoVendido(
      nombre: json['nombre']?.toString() ?? 'Plato',
      cantidad: (json['cantidad'] as num?)?.toInt() ?? 0,
      total: _numero(json['total']),
    );
  }
}

// Reporte de ventas de un día, un mes o un año
class Reporte {
  final double total;
  final int pedidos;
  final double ticketPromedio;
  final List<PuntoSerie> serie;
  final List<PlatoVendido> top;

  const Reporte({
    required this.total,
    required this.pedidos,
    required this.ticketPromedio,
    required this.serie,
    required this.top,
  });

  factory Reporte.fromJson(Map<String, dynamic> json) {
    final serie = (json['serie'] as List?) ?? [];
    final top = (json['top'] as List?) ?? [];

    return Reporte(
      total: _numero(json['total']),
      pedidos: (json['pedidos'] as num?)?.toInt() ?? 0,
      ticketPromedio: _numero(json['ticket_promedio']),
      serie: serie
          .map((s) => PuntoSerie.fromJson(Map<String, dynamic>.from(s)))
          .toList(),
      top: top
          .map((t) => PlatoVendido.fromJson(Map<String, dynamic>.from(t)))
          .toList(),
    );
  }
}