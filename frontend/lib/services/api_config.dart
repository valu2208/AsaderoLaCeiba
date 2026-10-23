import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  // Dirección fija opcional. Sirve para celular real o servidor publicado:
  //   flutter run --dart-define=API_URL=http://192.168.1.50:3000
  static const String _urlManual = String.fromEnvironment('API_URL');

  static String get baseUrl {
    // 1. Si se pasó API_URL al ejecutar, esa manda
    if (_urlManual.isNotEmpty) return _urlManual;

    // 2. Navegador: el backend está en la misma computadora
    if (kIsWeb) return 'http://localhost:3000';

    // 3. Emulador de Android: 10.0.2.2 es el "localhost" de tu computadora
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';

    // 4. Windows, macOS, Linux y simulador de iOS
    return 'http://localhost:3000';
  }

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}