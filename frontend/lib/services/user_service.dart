import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_config.dart';

class UserService {
  // Guardar sesión localmente en el dispositivo
  static Future<void> guardarSesion(String token, UserModel usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    await prefs.setString('user_id', usuario.id ?? '');
    await prefs.setString('user_nombre', usuario.nombre);
    await prefs.setString('user_email', usuario.email);
    await prefs.setString('user_rol', usuario.rol.toLowerCase());
  }

  // Obtener el token guardado
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Obtener el rol guardado (por defecto 'usuario')
  static Future<String> getRol() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_rol') ?? 'usuario';
  }

  // Cerrar sesión limpiando SharedPreferences
  static Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // POST a una ruta de autenticación; guarda la sesión y devuelve el usuario
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
      throw Exception(datos['error'] ?? datos['message'] ?? 'No se pudo iniciar sesión');
    }

    final usuario = UserModel.fromJson(datos['usuario'] ?? {});
    await guardarSesion(datos['token'] ?? '', usuario);
    return usuario;
  }

  // Login con correo y contraseña
  static Future<UserModel> loginUsuario(String email, String password) {
    return _autenticar('/auth/login', {'email': email, 'password': password});
  }

  // Login / registro con Google
  static Future<UserModel> loginGoogle(String idToken) {
    return _autenticar('/auth/google', {'idToken': idToken});
  }
}