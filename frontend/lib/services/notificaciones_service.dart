import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:asadero/services/api_config.dart';
import 'package:asadero/services/user_service.dart';

// Llamadas al servidor de las notificaciones. Si algo falla lanza
// Exception('clave_de_traduccion') para mostrar el mensaje en el idioma de la app.
class NotificacionesService {
  static Future<Map<String, String>> _cabeceras() async {
    final token = await UserService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('debes_iniciar_sesion_nuevamente');
    }

    return {...ApiConfig.headers, 'Authorization': 'Bearer $token'};
  }

  static Uri _url(String ruta) => Uri.parse('${ApiConfig.baseUrl}/notificaciones$ruta');

  // Cuántas notificaciones sin leer tiene el usuario; null si no hay sesión
  // o si el servidor no respondió bien
  static Future<int?> contarNoLeidas() async {
    final token = await UserService.getToken();

    if (token == null || token.isEmpty) return null;

    final respuesta = await http.get(
      _url('/no-leidas'),
      headers: {...ApiConfig.headers, 'Authorization': 'Bearer $token'},
    );

    if (respuesta.statusCode != 200) return null;

    final datos = jsonDecode(respuesta.body);
    return int.tryParse('${datos['no_leidas']}') ?? 0;
  }

  static Future<List<Map<String, dynamic>>> listar() async {
    final respuesta = await http.get(_url(''), headers: await _cabeceras());

    if (respuesta.statusCode != 200) {
      throw Exception('error_cargar_notificaciones');
    }

    final List<dynamic> datos = jsonDecode(respuesta.body);
    return datos.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  static Future<void> marcarLeida(String id) async {
    final respuesta = await http.patch(
      _url('/$id/leida'),
      headers: await _cabeceras(),
    );

    if (respuesta.statusCode != 200) {
      throw Exception('error_marcar_notificacion');
    }
  }

  // Borra solo las leídas; las que no se han leído se quedan
  static Future<void> eliminarLeidas() async {
    final respuesta = await http.delete(_url(''), headers: await _cabeceras());

    if (respuesta.statusCode != 200) {
      throw Exception('error_eliminar_notificaciones');
    }
  }

  // Pedido relacionado con una notificación (null si no tiene)
  static Future<Map<String, dynamic>?> pedidoDe(String id) async {
    final respuesta = await http.get(
      _url('/$id/pedido'),
      headers: await _cabeceras(),
    );

    if (respuesta.statusCode != 200) {
      throw Exception('error_cargar_notificaciones');
    }

    final datos = jsonDecode(respuesta.body);
    final pedido = datos['pedido'];
    return pedido == null ? null : Map<String, dynamic>.from(pedido);
  }
}