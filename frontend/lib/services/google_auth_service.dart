import 'package:google_sign_in/google_sign_in.dart';

// Se encarga solo de pedirle a Google el idToken; el backend lo valida en /auth/google
class GoogleAuthService {
  static const String _serverClientId =
      '1048054296808-qmul3sdksffmij6scb9rs71o16rjnm84.apps.googleusercontent.com';

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
    } on GoogleSignInException {
      throw Exception('No se pudo iniciar sesión con Google');
    }
  }
}