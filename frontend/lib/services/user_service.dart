import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_config.dart';

class UserService {
  static Future<void> guardarSesion(String token, UserModel usuario) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('jwt_token', token);
    await prefs.setString('user_id', usuario.id ?? '');
    await prefs.setString('user_nombre', usuario.nombre);
    await prefs.setString('user_email', usuario.email);
    await prefs.setString('user_telefono', usuario.telefono);
    await prefs.setString('user_rol', usuario.rol.toLowerCase());

    if (usuario.avatar != null && usuario.avatar!.isNotEmpty) {
      await prefs.setString('user_avatar', usuario.avatar!);
    } else {
      await prefs.remove('user_avatar');
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<String> getNombre() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_nombre') ?? '';
  }

  static Future<String?> getAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_avatar');
  }

  static Future<String> getRol() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_rol') ?? 'usuario';
  }

  static Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<UserModel> _autenticar(
    String ruta,
    Map<String, dynamic> cuerpo,
  ) async {
    final http.Response respuesta;

    try {
      respuesta = await http.post(
        Uri.parse('${ApiConfig.baseUrl}$ruta'),
        headers: ApiConfig.headers,
        body: jsonEncode(cuerpo),
      );
    } catch (_) {
      throw Exception('No se pudo conectar con el servidor');
    }

    Map<String, dynamic> datos;

    try {
      datos = jsonDecode(respuesta.body);
    } catch (_) {
      throw Exception('Respuesta inesperada (código ${respuesta.statusCode})');
    }

    if (respuesta.statusCode != 200) {
      throw Exception(
        datos['error'] ?? datos['message'] ?? 'No se pudo iniciar sesión',
      );
    }

    final usuario = UserModel.fromJson(
      Map<String, dynamic>.from(datos['usuario'] ?? {}),
    );

    await guardarSesion(datos['token'] ?? '', usuario);

    return usuario;
  }

  static Future<UserModel> loginUsuario(String email, String password) {
    return _autenticar('/auth/login', {'email': email, 'password': password});
  }

  static Future<UserModel> loginGoogle(String idToken) {
    return _autenticar('/auth/google', {'idToken': idToken});
  }

  static Future<void> actualizarPerfil({
    required String nombre,
    required String email,
    required String telefono,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final id = prefs.getString('user_id');
    final token = prefs.getString('jwt_token');

    if (id == null || id.isEmpty || token == null || token.isEmpty) {
      throw Exception(
        'No se encontró la sesión. Cierra sesión e inicia nuevamente.',
      );
    }

    final http.Response respuesta;

    try {
      respuesta = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/usuarios/$id'),
        headers: {...ApiConfig.headers, 'Authorization': 'Bearer $token'},
        body: jsonEncode({
          'nombre': nombre,
          'email': email,
          'telefono': telefono,
        }),
      );
    } catch (_) {
      throw Exception('No se pudo conectar con el servidor');
    }

    Map<String, dynamic> datos;

    try {
      datos = jsonDecode(respuesta.body);
    } catch (_) {
      throw Exception('Respuesta inesperada (código ${respuesta.statusCode})');
    }

    if (respuesta.statusCode != 200) {
      throw Exception(
        datos['error'] ??
            datos['message'] ??
            'No se pudieron actualizar los datos',
      );
    }

    // Actualizar la sesión solo después de confirmar el cambio.
    await prefs.setString('user_nombre', nombre);
    await prefs.setString('user_email', email);
    await prefs.setString('user_telefono', telefono);
  }

  static Future<void> eliminarCuenta() async {
    final prefs = await SharedPreferences.getInstance();

    final id = prefs.getString('user_id');
    final token = prefs.getString('jwt_token');

    if (id == null || id.isEmpty || token == null || token.isEmpty) {
      throw Exception('No se encontró la sesión. Inicia sesión nuevamente.');
    }

    final http.Response respuesta;

    try {
      respuesta = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/usuarios/$id'),
        headers: {...ApiConfig.headers, 'Authorization': 'Bearer $token'},
      );
    } catch (_) {
      throw Exception('No se pudo conectar con el servidor');
    }

    Map<String, dynamic> datos = {};

    try {
      datos = jsonDecode(respuesta.body);
    } catch (_) {
      if (respuesta.statusCode != 200) {
        throw Exception(
          'Respuesta inesperada (código ${respuesta.statusCode})',
        );
      }
    }

    if (respuesta.statusCode != 200) {
      throw Exception(
        datos['error'] ?? datos['message'] ?? 'No se pudo eliminar la cuenta',
      );
    }

    // Limpiar la sesión después de confirmar la eliminación.
    await prefs.clear();
  }
}
