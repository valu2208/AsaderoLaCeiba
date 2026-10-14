import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto_model.dart';
import 'api_config.dart';

// Solo CONSULTA los productos (GET /productos); lo usa la carta del cliente
class ProductoService {
  Future<List<ProductoModel>> obtenerProductos() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/productos');

    final http.Response response;
    try {
      response = await http.get(url, headers: ApiConfig.headers);
    } catch (_) {
      throw Exception('No se pudo conectar con el servidor');
    }

    if (response.statusCode != 200) {
      throw Exception('No se pudieron cargar los platos (código ${response.statusCode})');
    }

    try {
      final List<dynamic> datos = jsonDecode(response.body);
      return datos.map((item) => ProductoModel.fromJson(item)).toList();
    } catch (_) {
      throw Exception('El servidor respondió con datos inesperados');
    }
  }
}