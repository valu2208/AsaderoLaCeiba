import 'package:google_sign_in/google_sign_in.dart';

// Se encarga solo de pedirle a Google el idToken; el backend lo valida en /auth/google
class GoogleAuthService {
  static const String _serverClientId =
      '978670292562-6f3qglp23eod82ig7vcj1h3i52p3p0gm.apps.googleusercontent.com';

  static Future<void>? _inicializacion;

  static Future<String> obtenerIdToken() async {
    final google = GoogleSignIn.instance;
    _inicializacion ??= google.initialize(serverClientId: _serverClientId);
    await _inicializacion;

    try {
      final cuenta = await google.authenticate();
      final idToken = cuenta.authentication.idToken;
      if (idToken == null) {
        throw Exception('No se pudo obtener el token de Google');
      }
      return idToken;
    } on GoogleSignInException catch (e) {
      // Se deja el código real de Google para saber por qué falló.
      throw Exception('Google: ${e.code.name} ${e.description ?? ''}'.trim());
    }
  }
}
