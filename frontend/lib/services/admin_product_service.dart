import 'dart:convert';
import 'dart:io' show File;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/producto_model.dart';
import 'api_config.dart';
import 'user_service.dart';

class AdminProductService {
  // Obtener lista de productos
  Future<List<ProductoModel>> obtenerProductos() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/productos');

    try {
      final response = await http.get(url, headers: ApiConfig.headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ProductoModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar los productos');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Arma la parte "imagen" con su tipo real (image/jpeg, image/png...):
  // Cloudinary rechaza el archivo si no lo reconoce como imagen
  Future<http.MultipartFile> _archivoImagen(File imagen) async {
    final extension = imagen.path.split('.').last.toLowerCase();
    final subtipo = switch (extension) {
      'png' => 'png',
      'webp' => 'webp',
      'avif' => 'avif',
      _ => 'jpeg',
    };
    return http.MultipartFile.fromBytes(
      'imagen', // nombre del campo que espera Multer en el backend
      await imagen.readAsBytes(),
      contentType: MediaType('image', subtipo),
      filename: 'producto_${DateTime.now().millisecondsSinceEpoch}.${subtipo == 'jpeg' ? 'jpg' : subtipo}',
    );
  }

  // Crear (id == null) o editar (con id) un producto; la foto es opcional
  Future<void> guardarProducto({
    String? id,
    required String nombre,
    required String precio,
    required String descripcion,
    File? imagen,
  }) async {
    final token = await UserService.getToken();
    final base = '${ApiConfig.baseUrl}/productos';

    final request = http.MultipartRequest(
      id == null ? 'POST' : 'PUT',
      Uri.parse(id == null ? base : '$base/$id'),
    );
    if (token != null) request.headers['Authorization'] = 'Bearer $token';

    request.fields['nombre'] = nombre;
    request.fields['precio'] = precio;
    request.fields['descripcion'] = descripcion;
    if (imagen != null) request.files.add(await _archivoImagen(imagen));

    final respuesta = await http.Response.fromStream(await request.send());
    if (respuesta.statusCode != 200 && respuesta.statusCode != 201) {
      String mensaje = 'Error al guardar el producto';
      try {
        mensaje = jsonDecode(respuesta.body)['error'] ?? mensaje;
      } catch (_) {}
      throw Exception(mensaje);
    }
  }

  // Eliminar producto enviando el token JWT del administrador
  Future<void> eliminarProducto(String id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/productos/$id');
    final token = await UserService.getToken();

    final response = await http.delete(
      url,
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      String mensaje = 'No se pudo eliminar el producto';
      try {
        mensaje = jsonDecode(response.body)['error'] ?? mensaje;
      } catch (_) {}
      throw Exception(mensaje);
    }
  }
}