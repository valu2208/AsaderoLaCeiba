import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ingrediente.dart';
import 'api_config.dart';
import 'user_service.dart';

// Inventario de ingredientes: ver y ajustar stock (cocinero y admin);
// crear, editar y eliminar (solo admin)
class InventarioService {
  Future<Map<String, String>> _cabeceras() async {
    final token = await UserService.getToken();
    return {
      ...ApiConfig.headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  String _mensajeError(http.Response respuesta, String porDefecto) {
    try {
      return jsonDecode(respuesta.body)['error'] ?? porDefecto;
    } catch (_) {
      return porDefecto;
    }
  }

  // Ejecuta la petición y unifica el error de conexión
  Future<http.Response> _llamar(Future<http.Response> Function() peticion) async {
    try {
      return await peticion();
    } catch (_) {
      throw Exception('No se pudo conectar con el servidor');
    }
  }

  // Lanza el error del backend si el código no es el esperado
  void _validar(http.Response respuesta, int esperado, String porDefecto) {
    if (respuesta.statusCode != esperado) {
      throw Exception(_mensajeError(respuesta, porDefecto));
    }
  }

  Future<List<Ingrediente>> listar() async {
    final respuesta = await _llamar(() async => http.get(
          Uri.parse('${ApiConfig.baseUrl}/inventario'),
          headers: await _cabeceras(),
        ));
    _validar(respuesta, 200, 'No se pudo cargar el inventario');

    final List<dynamic> datos = jsonDecode(respuesta.body);
    return datos
        .map((d) => Ingrediente.fromJson(Map<String, dynamic>.from(d)))
        .toList();
  }

  Future<void> actualizarStock(int id, int stock) async {
    final respuesta = await _llamar(() async => http.put(
          Uri.parse('${ApiConfig.baseUrl}/inventario/$id/stock'),
          headers: await _cabeceras(),
          body: jsonEncode({'stock_actual': stock}),
        ));
    _validar(respuesta, 200, 'No se pudo actualizar el stock');
  }

  // Admin: crear un ingrediente nuevo
  Future<void> crear({
    required String nombre,
    required String unidad,
    required int stockActual,
    required int stockMinimo,
  }) async {
    final respuesta = await _llamar(() async => http.post(
          Uri.parse('${ApiConfig.baseUrl}/inventario'),
          headers: await _cabeceras(),
          body: jsonEncode({
            'ingrediente': nombre,
            'unidad_medida': unidad,
            'stock_actual': stockActual,
            'stock_minimo': stockMinimo,
          }),
        ));
    _validar(respuesta, 201, 'No se pudo crear el ingrediente');
  }

  // Admin: cambiar nombre, unidad o mínimo (el stock se ajusta aparte)
  Future<void> editar(
    int id, {
    required String nombre,
    required String unidad,
    required int stockMinimo,
  }) async {
    final respuesta = await _llamar(() async => http.put(
          Uri.parse('${ApiConfig.baseUrl}/inventario/$id'),
          headers: await _cabeceras(),
          body: jsonEncode({
            'ingrediente': nombre,
            'unidad_medida': unidad,
            'stock_minimo': stockMinimo,
          }),
        ));
    _validar(respuesta, 200, 'No se pudo editar el ingrediente');
  }

  // Admin: eliminar un ingrediente
  Future<void> eliminar(int id) async {
    final respuesta = await _llamar(() async => http.delete(
          Uri.parse('${ApiConfig.baseUrl}/inventario/$id'),
          headers: await _cabeceras(),
        ));
    _validar(respuesta, 200, 'No se pudo eliminar el ingrediente');
  }
}