import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ingrediente.dart';
import 'api_config.dart';
import 'user_service.dart';

// Inventario de ingredientes (solo cocinero y admin)
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

  Future<List<Ingrediente>> listar() async {
    final http.Response respuesta;
    try {
      respuesta = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/inventario'),
        headers: await _cabeceras(),
      );
    } catch (_) {
      throw Exception('No se pudo conectar con el servidor');
    }

    if (respuesta.statusCode != 200) {
      throw Exception(_mensajeError(respuesta, 'No se pudo cargar el inventario'));
    }

    final List<dynamic> datos = jsonDecode(respuesta.body);
    return datos
        .map((d) => Ingrediente.fromJson(Map<String, dynamic>.from(d)))
        .toList();
  }

  Future<void> actualizarStock(int id, int stock) async {
    final http.Response respuesta;
    try {
      respuesta = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/inventario/$id/stock'),
        headers: await _cabeceras(),
        body: jsonEncode({'stock_actual': stock}),
      );
    } catch (_) {
      throw Exception('No se pudo conectar con el servidor');
    }

    if (respuesta.statusCode != 200) {
      throw Exception(_mensajeError(respuesta, 'No se pudo actualizar el stock'));
    }
  }
}