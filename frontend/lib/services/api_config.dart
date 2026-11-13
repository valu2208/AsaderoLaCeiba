import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  static const bool useRemote = true;

  static const String _remoteUrl =
      'https://asadero-la-ceiba-gigante.onrender.com';

  static const String _urlManual = String.fromEnvironment('API_URL');

  static String get baseUrl {
    if (_urlManual.isNotEmpty) return _urlManual;

    if (useRemote) return _remoteUrl;

    if (kIsWeb) return 'http://localhost:3000';

    if (Platform.isAndroid) return 'http://10.0.2.2:3000';

    return 'http://localhost:3000';
  }

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
