class ProductoModel {
  final String id;
  final String nombre;
  final double precio;
  final String descripcion;
  final String? imagenUrl;
  final bool activo;
  final String categoria;
  final bool masPedido;
  final List<String> dias;

  // Traducciones
  final String nombreEn;
  final String descripcionEn;
  final String nombrePt;
  final String descripcionPt;

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
    this.nombreEn = '',
    this.descripcionEn = '',
    this.nombrePt = '',
    this.descripcionPt = '',
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      precio: (json['precio'] as num?)?.toDouble() ?? 0.0,
      descripcion: json['descripcion']?.toString() ?? '',
      imagenUrl: json['imagenUrl'] ?? json['imagen_url'] ?? json['imagen'],
      activo: json['activo'] as bool? ?? true,
      categoria: json['categoria']?.toString() ?? '',
      masPedido: json['mas_pedido'] as bool? ?? false,
      dias: (json['dias'] as List?)?.map((d) => d.toString()).toList() ?? [],
      nombreEn: json['nombre_en']?.toString() ?? '',
      descripcionEn:
          json['description_en']?.toString() ??
          json['descripcion_en']?.toString() ??
          '',
      nombrePt: json['nombre_pt']?.toString() ?? '',
      descripcionPt: json['descripcion_pt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'descripcion': descripcion,
      'nombre_en': nombreEn,
      'description_en': descripcionEn,
      'nombre_pt': nombrePt,
      'descripcion_pt': descripcionPt,
      'activo': activo,
      'categoria': categoria,
      'mas_pedido': masPedido,
      'dias': dias,
      if (imagenUrl != null) 'imagenUrl': imagenUrl,
    };
  }
}
