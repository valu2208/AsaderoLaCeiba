import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pedido_personal.dart';
import 'api_config.dart';
import 'user_service.dart';

// Pedidos para el personal. rol: 'mesero' o 'cocina' (así empieza la ruta del servidor)
class PedidoPersonalService {
  Future<Map<String, String>> _cabeceras() async {
    final token = await UserService.getToken();
    return {
      ...ApiConfig.headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Saca el mensaje de error que manda el servidor
  String _mensajeError(http.Response respuesta, String porDefecto) {
    try {
      return jsonDecode(respuesta.body)['error'] ?? porDefecto;
    } catch (_) {
      return porDefecto;
    }
  }

  Future<List<PedidoPersonal>> listar(String rol) async {
    final http.Response respuesta;
    try {
      respuesta = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/$rol/pedidos'),
        headers: await _cabeceras(),
      );
    } catch (_) {
      throw Exception('No se pudo conectar con el servidor');
    }

    if (respuesta.statusCode != 200) {
      throw Exception(_mensajeError(respuesta, 'No se pudieron cargar los pedidos'));
    }

    final List<dynamic> datos = jsonDecode(respuesta.body);
    return datos
        .map((d) => PedidoPersonal.fromJson(Map<String, dynamic>.from(d)))
        .toList();
  }

  // "mesa" solo se envía cuando el mesero manda el pedido a cocina
  Future<void> cambiarEstado(String rol, int id, String estado, {int? mesa}) async {
    final http.Response respuesta;
    try {
      respuesta = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/$rol/pedidos/$id/estado'),
        headers: await _cabeceras(),
        body: jsonEncode({
          'estado': estado,
          if (mesa != null) 'mesa': mesa,
        }),
      );
    } catch (_) {
      throw Exception('No se pudo conectar con el servidor');
    }

    if (respuesta.statusCode != 200) {
      throw Exception(_mensajeError(respuesta, 'No se pudo actualizar el pedido'));
    }
  }
}