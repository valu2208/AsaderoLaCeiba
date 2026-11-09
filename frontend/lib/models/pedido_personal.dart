// Un plato dentro de un pedido
class ItemPedido {
  final String nombre;
  final int cantidad;

  const ItemPedido({required this.nombre, required this.cantidad});

  factory ItemPedido.fromJson(Map<String, dynamic> json) {
    return ItemPedido(
      nombre: json['nombre']?.toString() ?? 'Plato',
      cantidad: (json['cantidad'] as num?)?.toInt() ?? 1,
    );
  }
}

// Pedido tal como lo ven el mesero y la cocina
class PedidoPersonal {
  final int id;
  final String estado;
  final String? fecha;
  final double total;
  final String notas;
  final String cliente;
  final int? mesa; // la pone el mesero al enviar a cocina
  final List<ItemPedido> items;

  const PedidoPersonal({
    required this.id,
    required this.estado,
    required this.fecha,
    required this.total,
    required this.notas,
    required this.cliente,
    required this.mesa,
    required this.items,
  });

  factory PedidoPersonal.fromJson(Map<String, dynamic> json) {
    final lista = (json['items'] as List?) ?? [];

    return PedidoPersonal(
      id: (json['id'] as num).toInt(),
      estado: json['estado']?.toString() ?? '',
      fecha: json['fecha_pedido']?.toString(),
      total: (json['total'] as num?)?.toDouble() ?? 0,
      notas: json['notas']?.toString() ?? '',
      cliente: json['cliente']?.toString() ?? 'Cliente',
      mesa: (json['mesa'] as num?)?.toInt(),
      items: lista
          .map((i) => ItemPedido.fromJson(Map<String, dynamic>.from(i)))
          .toList(),
    );
  }

  // "Hace 5 min". La base guarda la hora en UTC sin zona, por eso se agrega la Z.
  String get hace {
    final texto = fecha;
    if (texto == null) return '';

    final conZona =
        RegExp(r'(Z|[+-]\d\d:?\d\d)$').hasMatch(texto) ? texto : '${texto}Z';
    final momento = DateTime.tryParse(conZona);
    if (momento == null) return '';

    final minutos = DateTime.now().difference(momento).inMinutes;
    if (minutos < 1) return 'Ahora';
    if (minutos < 60) return 'Hace $minutos min';

    final horas = minutos ~/ 60;
    if (horas < 24) return 'Hace $horas h';
    return 'Hace ${horas ~/ 24} d';
  }
}