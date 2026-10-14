import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'api_config.dart';
import 'user_service.dart';

// Llamadas del administrador a /usuarios (todas llevan el token JWT)
class AdminUserService {
  Future<Map<String, String>> _headers() async {
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

  // Lista de todos los usuarios registrados
  Future<List<UserModel>> obtenerUsuarios() async {
    final http.Response respuesta;
    try {
      respuesta = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/usuarios'),
        headers: await _headers(),
      );
    } catch (_) {
      throw Exception('No se pudo conectar con el servidor');
    }

    if (respuesta.statusCode != 200) {
      throw Exception(_mensajeError(respuesta, 'No se pudieron cargar los usuarios'));
    }

    final List<dynamic> datos = jsonDecode(respuesta.body);
    return datos.map((u) => UserModel.fromJson(u)).toList();
  }

  // Asigna un nuevo rol a un usuario
  Future<void> cambiarRol(String id, String rol) async {
    final http.Response respuesta;
    try {
      respuesta = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/usuarios/$id/rol'),
        headers: await _headers(),
        body: jsonEncode({'rol': rol}),
      );
    } catch (_) {
      throw Exception('No se pudo conectar con el servidor');
    }

    if (respuesta.statusCode != 200) {
      throw Exception(_mensajeError(respuesta, 'No se pudo cambiar el rol'));
    }
  }
}