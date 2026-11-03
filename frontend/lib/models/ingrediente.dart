// Un ingrediente del inventario (tabla inventario_ingredientes)
class Ingrediente {
  final int id;
  final String nombre;
  final int stockActual;
  final int stockMinimo;
  final String unidad;

  const Ingrediente({
    required this.id,
    required this.nombre,
    required this.stockActual,
    required this.stockMinimo,
    required this.unidad,
  });

  factory Ingrediente.fromJson(Map<String, dynamic> json) {
    return Ingrediente(
      id: (json['id'] as num).toInt(),
      nombre: json['ingrediente']?.toString() ?? '',
      stockActual: (json['stock_actual'] as num?)?.toInt() ?? 0,
      stockMinimo: (json['stock_minimo'] as num?)?.toInt() ?? 0,
      unidad: json['unidad_medida']?.toString() ?? '',
    );
  }

  // Está bajo cuando llegó al mínimo o menos
  bool get bajo => stockActual <= stockMinimo;
}