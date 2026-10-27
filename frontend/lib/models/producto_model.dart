class ProductoModel {
  final String id;
  final String nombre;
  final double precio;
  final String descripcion;
  final String? imagenUrl;
  final bool activo;
  final String categoria; // desayuno, almuerzo, fin_de_semana, gaseosas
  final bool masPedido; // aparece en "Lo más pedido"
  final List<String> dias; // días en que se sirve: lunes, martes, ...

  ProductoModel({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.descripcion,
    this.imagenUrl,
    this.activo = true,
    this.categoria = '',
    this.masPedido = false,
    this.dias = const [],
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      nombre: json['nombre'] ?? '',
      precio: (json['precio'] as num?)?.toDouble() ?? 0.0,
      descripcion: json['descripcion'] ?? '',
      imagenUrl: json['imagenUrl'] ??
          json['imagen_url'] ??
          json['imagen'],
      activo: json['activo'] as bool? ?? true,
      categoria: json['categoria']?.toString() ?? '',
      masPedido: json['mas_pedido'] as bool? ?? false,
      dias: (json['dias'] as List?)?.map((d) => d.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'descripcion': descripcion,
      'activo': activo,
      'categoria': categoria,
      'mas_pedido': masPedido,
      'dias': dias,
      if (imagenUrl != null) 'imagenUrl': imagenUrl,
    };
  }
}