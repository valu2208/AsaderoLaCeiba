import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// "Recordarme" del login: guarda el correo y la contraseña en el almacenamiento
// cifrado del celular (no en SharedPreferences, que es texto plano)
class CredencialesService {
  static const FlutterSecureStorage _almacen = FlutterSecureStorage();

  static const _claveCorreo = 'recordar_correo';
  static const _claveContrasena = 'recordar_contrasena';

  // Devuelve [correo, contraseña], o null si no hay nada guardado
  static Future<List<String>?> leer() async {
    try {
      final correo = await _almacen.read(key: _claveCorreo);
      final clave = await _almacen.read(key: _claveContrasena);

      if (correo == null || correo.isEmpty) return null;

      return [correo, clave ?? ''];
    } catch (_) {
      return null;
    }
  }

  // Con la casilla marcada guarda; sin marcar borra lo que hubiera
  static Future<void> actualizar(bool recordar, String correo, String clave) async {
    try {
      if (recordar) {
        await _almacen.write(key: _claveCorreo, value: correo);
        await _almacen.write(key: _claveContrasena, value: clave);
      } else {
        await _almacen.delete(key: _claveCorreo);
        await _almacen.delete(key: _claveContrasena);
      }
    } catch (_) {
      // Si el celular no deja guardar, el login igual continúa
    }
  }
}