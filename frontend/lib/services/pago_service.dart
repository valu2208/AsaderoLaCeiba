import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'user_service.dart';

class PagoService {
  Future<Map<String, String>> _cabeceras() async {
    final token = await UserService.getToken();
    return {
      ...ApiConfig.headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Exception _error(http.Response r, String porDefecto) {
    try {
      return Exception(jsonDecode(r.body)['error'] ?? porDefecto);
    } catch (_) {
      return Exception(porDefecto);
    }
  }

  Future<List<Map<String, dynamic>>> pendientes() async {
    final r = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/admin/pagos/comprobantes'),
      headers: await _cabeceras(),
    );
    if (r.statusCode != 200) throw _error(r, 'No se pudieron cargar los comprobantes');

    final datos = jsonDecode(r.body);
    if (datos is! List) return [];
    return datos.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> revisar(int id, String estado, {String? observacion}) async {
    final r = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/api/admin/pedidos/$id/pago'),
      headers: await _cabeceras(),
      body: jsonEncode({'estado_pago': estado, 'observacion': observacion}),
    );
    if (r.statusCode != 200) throw _error(r, 'No se pudo actualizar el pago');
  }
}