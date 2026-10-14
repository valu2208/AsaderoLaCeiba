class ProductoModel {
  final String id;
  final String nombre;
  final double precio;
  final String descripcion;
  final String? imagenUrl;

  ProductoModel({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.descripcion,
    this.imagenUrl,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      nombre: json['nombre'] ?? '',
      precio: (json['precio'] as num?)?.toDouble() ?? 0.0,
      descripcion: json['descripcion'] ?? '',
      // Soporta diferentes nombres de campos que pueda retornar el backend de Node
      imagenUrl: json['imagenUrl'] ?? json['imagen_url'] ?? json['imagen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'descripcion': descripcion,
      if (imagenUrl != null) 'imagenUrl': imagenUrl,
    };
  }
}