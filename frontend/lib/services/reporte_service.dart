import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reporte.dart';
import 'api_config.dart';
import 'user_service.dart';

// Reportes de ventas (solo admin). El router de pedidos está montado en /api.
class ReporteService {
  Future<Map<String, String>> _cabeceras() async {
    final token = await UserService.getToken();
    return {
      ...ApiConfig.headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  String _dosDigitos(int n) => n.toString().padLeft(2, '0');

  // periodo: 'dia', 'mes' o 'anio'
  Future<Reporte> obtener(String periodo, DateTime fecha) async {
    final texto = '${fecha.year}-${_dosDigitos(fecha.month)}-${_dosDigitos(fecha.day)}';

    final http.Response respuesta;
    try {
      respuesta = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/admin/reportes?periodo=$periodo&fecha=$texto'),
        headers: await _cabeceras(),
      );
    } catch (_) {
      throw Exception('No se pudo conectar con el servidor');
    }

    if (respuesta.statusCode != 200) {
      String mensaje = 'No se pudo cargar el reporte';
      try {
        mensaje = jsonDecode(respuesta.body)['error'] ?? mensaje;
      } catch (_) {}
      throw Exception(mensaje);
    }

    return Reporte.fromJson(Map<String, dynamic>.from(jsonDecode(respuesta.body)));
  }
}