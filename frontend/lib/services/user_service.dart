import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import 'api_config.dart';

class UserService {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> guardarSesion(
    String token,
    UserModel usuario, {
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('jwt_token', token);
    await _secureStorage.write(key: 'refresh_token', value: refreshToken);

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

  // Comprobar si el Access Token está próximo a caducar.
  static bool _tokenExpirado(String token) {
    try {
      final partes = token.split('.');
      if (partes.length != 3) return true;

      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(partes[1]))),
      );

      final expiracion = payload['exp'] as int;

      return expiracion * 1000 <= DateTime.now().millisecondsSinceEpoch + 60000;
    } catch (_) {
      return true;
    }
  }

  // Renovar el Access Token utilizando el Refresh Token.
  static Future<String?> _renovarSesion() async {
    final refreshToken = await _secureStorage.read(key: 'refresh_token');

    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    final http.Response respuesta;

    try {
      respuesta = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/refresh'),
        headers: ApiConfig.headers,
        body: jsonEncode({'refreshToken': refreshToken}),
      );
    } catch (_) {
      throw Exception('No se pudo conectar para renovar la sesión.');
    }

    Map<String, dynamic> datos;

    try {
      datos = jsonDecode(respuesta.body);
    } catch (_) {
      throw Exception('Respuesta inesperada al renovar la sesión.');
    }

    if (respuesta.statusCode != 200) {
      return null;
    }

    final nuevoToken = datos['token'];
    final nuevoRefreshToken = datos['refreshToken'];

    if (nuevoToken == null || nuevoRefreshToken == null) {
      throw Exception('El servidor no devolvió los nuevos tokens.');
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('jwt_token', nuevoToken);

    await _secureStorage.write(key: 'refresh_token', value: nuevoRefreshToken);

    return nuevoToken;
  }

  // Obtener un Access Token válido.
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null || token.isEmpty) {
      return null;
    }

    if (!_tokenExpirado(token)) {
      return token;
    }

    return await _renovarSesion();
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

  // Cerrar sesión.
  static Future<void> cerrarSesion() async {
    final refreshToken = await _secureStorage.read(key: 'refresh_token');

    if (refreshToken != null && refreshToken.isNotEmpty) {
      try {
        await http.post(
          Uri.parse('${ApiConfig.baseUrl}/auth/logout'),
          headers: ApiConfig.headers,
          body: jsonEncode({'refreshToken': refreshToken}),
        );
      } catch (_) {
        // La sesión local se cerrará aunque no haya conexión.
      }
    }

    final prefs = await SharedPreferences.getInstance();

    for (final clave in [
      'jwt_token',
      'user_id',
      'user_nombre',
      'user_email',
      'user_telefono',
      'user_rol',
      'user_avatar',
    ]) {
      await prefs.remove(clave);
    }

    await _secureStorage.delete(key: 'refresh_token');
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

    final token = datos['token'];
    final refreshToken = datos['refreshToken'];

    if (token == null || refreshToken == null) {
      throw Exception('El servidor no devolvió los tokens de sesión.');
    }

    await guardarSesion(token, usuario, refreshToken: refreshToken);

    return usuario;
  }

  static Future<UserModel> loginUsuario(String email, String password) {
    return _autenticar('/auth/login', {'email': email, 'password': password});
  }

  static Future<UserModel> loginGoogle(String idToken) {
    return _autenticar('/auth/google', {'idToken': idToken});
  }

  // Actualizar únicamente nombre y teléfono.
  static Future<void> actualizarPerfil({
    required String nombre,
    required String telefono,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('user_id');

    if (id == null || id.isEmpty) {
      throw Exception('No se encontró la sesión. Inicia sesión nuevamente.');
    }

    String? token = await getToken();

    if (token == null) {
      throw Exception('Tu sesión ha expirado. Inicia sesión nuevamente.');
    }

    http.Response respuesta;

    try {
      respuesta = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/usuarios/$id'),
        headers: {...ApiConfig.headers, 'Authorization': 'Bearer $token'},
        body: jsonEncode({'nombre': nombre, 'telefono': telefono}),
      );

      if (respuesta.statusCode == 401) {
        token = await _renovarSesion();

        if (token == null) {
          throw Exception('Tu sesión ha expirado. Inicia sesión nuevamente.');
        }

        respuesta = await http.put(
          Uri.parse('${ApiConfig.baseUrl}/usuarios/$id'),
          headers: {...ApiConfig.headers, 'Authorization': 'Bearer $token'},
          body: jsonEncode({'nombre': nombre, 'telefono': telefono}),
        );
      }
    } catch (error) {
      if (error is Exception) rethrow;
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

    await prefs.setString('user_nombre', nombre);
    await prefs.setString('user_telefono', telefono);
  }

  // Subir y guardar la foto de perfil.
  static Future<String> actualizarAvatar(XFile imagen) async {
    String? token = await getToken();

    if (token == null) {
      throw Exception('Tu sesión ha expirado. Inicia sesión nuevamente.');
    }

    Future<http.Response> enviarImagen(String accessToken) async {
      final solicitud = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/usuarios/avatar'),
      );

      solicitud.headers['Authorization'] = 'Bearer $accessToken';

      solicitud.files.add(
        await http.MultipartFile.fromPath('avatar', imagen.path),
      );

      final respuesta = await solicitud.send();

      return await http.Response.fromStream(respuesta);
    }

    http.Response respuesta;

    try {
      respuesta = await enviarImagen(token);

      if (respuesta.statusCode == 401) {
        token = await _renovarSesion();

        if (token == null) {
          throw Exception('Tu sesión ha expirado. Inicia sesión nuevamente.');
        }

        respuesta = await enviarImagen(token);
      }
    } catch (error) {
      if (error is Exception) rethrow;
      throw Exception('No se pudo enviar la foto de perfil.');
    }

    Map<String, dynamic> datos;

    try {
      datos = jsonDecode(respuesta.body);
    } catch (_) {
      throw Exception('Respuesta inesperada al subir la fotografía.');
    }

    if (respuesta.statusCode != 200) {
      throw Exception(
        datos['error'] ??
            datos['message'] ??
            'No se pudo actualizar la foto de perfil.',
      );
    }

    final avatar = datos['avatar'];

    if (avatar == null || avatar.toString().isEmpty) {
      throw Exception('El servidor no devolvió la URL de la fotografía.');
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_avatar', avatar.toString());

    return avatar.toString();
  }

  // Cambiar contraseña verificando la contraseña actual.
  static Future<void> cambiarContrasena({
    required String passwordActual,
    required String nuevaPassword,
  }) async {
    String? token = await getToken();

    if (token == null) {
      throw Exception('Tu sesión ha expirado. Inicia sesión nuevamente.');
    }

    http.Response respuesta;

    try {
      respuesta = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/usuarios/cambiar-contrasena'),
        headers: {...ApiConfig.headers, 'Authorization': 'Bearer $token'},
        body: jsonEncode({
          'passwordActual': passwordActual,
          'nuevaPassword': nuevaPassword,
        }),
      );

      if (respuesta.statusCode == 401) {
        token = await _renovarSesion();

        if (token == null) {
          throw Exception('Tu sesión ha expirado. Inicia sesión nuevamente.');
        }

        respuesta = await http.put(
          Uri.parse('${ApiConfig.baseUrl}/usuarios/cambiar-contrasena'),
          headers: {...ApiConfig.headers, 'Authorization': 'Bearer $token'},
          body: jsonEncode({
            'passwordActual': passwordActual,
            'nuevaPassword': nuevaPassword,
          }),
        );
      }
    } catch (error) {
      if (error is Exception) rethrow;
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
            'No se pudo cambiar la contraseña',
      );
    }
  }

  // Eliminar cuenta.
  static Future<void> eliminarCuenta() async {
    final prefs = await SharedPreferences.getInstance();

    final id = prefs.getString('user_id');

    if (id == null || id.isEmpty) {
      throw Exception('No se encontró la sesión. Inicia sesión nuevamente.');
    }

    String? token = await getToken();

    if (token == null) {
      throw Exception('Tu sesión ha expirado. Inicia sesión nuevamente.');
    }

    http.Response respuesta;

    try {
      respuesta = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/usuarios/$id'),
        headers: {...ApiConfig.headers, 'Authorization': 'Bearer $token'},
      );

      if (respuesta.statusCode == 401) {
        token = await _renovarSesion();

        if (token == null) {
          throw Exception('Tu sesión ha expirado. Inicia sesión nuevamente.');
        }

        respuesta = await http.delete(
          Uri.parse('${ApiConfig.baseUrl}/usuarios/$id'),
          headers: {...ApiConfig.headers, 'Authorization': 'Bearer $token'},
        );
      }
    } catch (error) {
      if (error is Exception) rethrow;
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

    await cerrarSesion();
  }
}
