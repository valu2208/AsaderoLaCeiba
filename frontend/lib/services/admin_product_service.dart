import 'dart:convert';
import 'dart:io' show File;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/producto_model.dart';
import 'api_config.dart';
import 'user_service.dart';

class AdminProductService {
  // Cabeceras con el token del administrador
  Future<Map<String, String>> _cabeceras() async {
    final token = await UserService.getToken();
    return {
      ...ApiConfig.headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Saca el mensaje de error que manda el backend
  String _mensajeError(http.Response respuesta, String porDefecto) {
    try {
      return jsonDecode(respuesta.body)['error'] ?? porDefecto;
    } catch (_) {
      return porDefecto;
    }
  }

  // Productos activos e inactivos. Filtros opcionales:
  //   masPedido: true -> solo "Lo más pedido" | false -> solo el menú
  //   categoria: 'desayuno', 'almuerzo', 'fin_de_semana' o 'gaseosas'
  //   dia: 'lunes' ... 'domingo'
  Future<List<ProductoModel>> obtenerProductos({
    bool? masPedido,
    String? categoria,
    String? dia,
  }) async {
    final filtros = <String, String>{
      if (masPedido != null) 'mas_pedido': masPedido.toString(),
      if (categoria != null) 'categoria': categoria,
      if (dia != null) 'dia': dia,
    };
    final url = Uri.parse('${ApiConfig.baseUrl}/productos/admin/todos')
        .replace(queryParameters: filtros.isEmpty ? null : filtros);

    final http.Response response;
    try {
      response = await http.get(url, headers: await _cabeceras());
    } catch (_) {
      throw Exception('No se pudo conectar con el servidor');
    }

    if (response.statusCode != 200) {
      throw Exception(_mensajeError(response, 'Error al cargar los productos'));
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => ProductoModel.fromJson(json)).toList();
  }

  // Preparar la imagen para Cloudinary
  Future<http.MultipartFile> _archivoImagen(File imagen) async {
    final extension = imagen.path.split('.').last.toLowerCase();

    final subtipo = switch (extension) {
      'png' => 'png',
      'webp' => 'webp',
      'avif' => 'avif',
      _ => 'jpeg',
    };

    return http.MultipartFile.fromBytes(
      'imagen',
      await imagen.readAsBytes(),
      contentType: MediaType('image', subtipo),
      filename:
          'producto_${DateTime.now().millisecondsSinceEpoch}.'
          '${subtipo == 'jpeg' ? 'jpg' : subtipo}',
    );
  }

  // Crear o editar un producto.
  // categoria / masPedido / dias: si van null no se envían (se conserva lo guardado)
  Future<void> guardarProducto({
    String? id,
    required String nombre,
    required String precio,
    required String descripcion,
    File? imagen,
    String? categoria,
    bool? masPedido,
    List<String>? dias,
  }) async {
    final base = '${ApiConfig.baseUrl}/productos';
    final request = http.MultipartRequest(
      id == null ? 'POST' : 'PUT',
      Uri.parse(id == null ? base : '$base/$id'),
    );

    request.headers.addAll(await _cabeceras());
    request.headers.remove('Content-Type'); // lo pone el multipart
    request.fields['nombre'] = nombre;
    request.fields['precio'] = precio;
    request.fields['descripcion'] = descripcion;
    if (categoria != null) request.fields['categoria'] = categoria;
    if (masPedido != null) request.fields['mas_pedido'] = masPedido.toString();
    if (dias != null) request.fields['dias'] = dias.join(','); // 'lunes,martes'

    if (imagen != null) {
      request.files.add(await _archivoImagen(imagen));
    }

    final respuesta = await http.Response.fromStream(await request.send());

    if (respuesta.statusCode != 200 && respuesta.statusCode != 201) {
      throw Exception(_mensajeError(respuesta, 'Error al guardar el producto'));
    }
  }

  // Envía DELETE / PATCH a /productos y revisa la respuesta
  Future<void> _enviar(String metodo, String ruta, String porDefecto) async {
    final request = http.Request(metodo, Uri.parse('${ApiConfig.baseUrl}/productos$ruta'));
    request.headers.addAll(await _cabeceras());

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(_mensajeError(response, porDefecto));
    }
  }

  Future<void> eliminarProducto(String id) =>
      _enviar('DELETE', '/$id', 'No se pudo desactivar el producto');

  Future<void> activarProducto(String id) =>
      _enviar('PATCH', '/$id/activar', 'No se pudo activar el producto');

  Future<void> eliminarProductoDefinitivamente(String id) => _enviar(
        'DELETE',
        '/$id/definitivo',
        'No se pudo eliminar el producto definitivamente',
      );
}