import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  // Cambia a false cuando quieras volver a probar con tu servidor Node.js local.
  static const bool useRemote = true;

  // URL de tu backend desplegado en Render.
  static const String _remoteUrl =
      'https://asadero-la-ceiba-gigante.onrender.com';

  // Dirección fija opcional. Sirve para celular real o servidor publicado:
  //   flutter run --dart-define=API_URL=http://192.168.1.50:3000
  static const String _urlManual = String.fromEnvironment('API_URL');

  static String get baseUrl {
    // 1. Si se pasó API_URL al ejecutar, esa manda
    if (_urlManual.isNotEmpty) return _urlManual;

    // 2. Servidor publicado en Render
    if (useRemote) return _remoteUrl;

    // 3. Navegador: el backend está en la misma computadora
    if (kIsWeb) return 'http://localhost:3000';

    // 4. Emulador de Android: 10.0.2.2 es el "localhost" de tu computadora
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';

    // 5. Windows, macOS, Linux y simulador de iOS
    return 'http://localhost:3000';
  }

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}