import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto_model.dart';
import 'api_config.dart';

// Solo CONSULTA los productos que ve el cliente
class ProductoService {
  // Home: "Lo más pedido"
  Future<List<ProductoModel>> obtenerMasPedidos() async =>
      (await _pedir('/productos'))
          .where((producto) => producto.masPedido)
          .toList();

  // Menú: desayuno, almuerzo, fin_de_semana o gaseosas
  // dia: 'lunes' ... 'domingo' -> solo los platos de ese día
  Future<List<ProductoModel>> obtenerPorCategoria(String categoria, {String? dia}) =>
      _pedir('/productos/categoria/$categoria${dia == null ? '' : '?dia=$dia'}');

  // Todos los productos activos
  Future<List<ProductoModel>> obtenerProductos() => _pedir('/productos');

  Future<List<ProductoModel>> _pedir(String ruta) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$ruta');

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