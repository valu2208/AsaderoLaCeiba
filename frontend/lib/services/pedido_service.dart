import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asadero/core/carrito_estado.dart';
import 'package:asadero/services/api_config.dart';
import 'package:asadero/services/user_service.dart';

class PedidoService {
  Future<int> realizarPedido(
    List<CarritoItem> items, {
    String metodoPago = 'presencial',
  }) async {
    if (items.isEmpty) {
      throw Exception('El carrito está vacío.');
    }

    final token = await UserService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Tu sesión ha expirado. Inicia sesión nuevamente.');
    }

    final prefs = await SharedPreferences.getInstance();
    final telefono = prefs.getString('user_telefono') ?? '';

    final productos = <Map<String, dynamic>>[];
    double total = 0;

    for (final item in items) {
      final id = int.tryParse(item.productoId);
      final precioTexto = item.precio.replaceAll(RegExp(r'[^0-9]'), '');
      final precio = double.tryParse(precioTexto);

      if (id == null || precio == null || precio <= 0) {
        throw Exception('No se pudo validar el producto ${item.nombre}.');
      }

      productos.add({
        'producto_id': id,
        'cantidad': item.cantidad,
        'precio_unitario': precio,
      });

      total += precio * item.cantidad;
    }

    final respuesta = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/pedidos'),
      headers: {...ApiConfig.headers, 'Authorization': 'Bearer $token'},
      body: jsonEncode({
        'total': total,
        'moneda_pago': 'COP',
        'metodo_pago': metodoPago,
        'telefono': telefono.isEmpty ? null : telefono,
        'productos': productos,
      }),
    );

    Map<String, dynamic> datos;

    try {
      datos = Map<String, dynamic>.from(jsonDecode(respuesta.body));
    } catch (_) {
      throw Exception(
        'El servidor respondió inesperadamente '
        '(código ${respuesta.statusCode}).',
      );
    }

    if (respuesta.statusCode != 201) {
      throw Exception(
        datos['error'] ?? datos['message'] ?? 'No se pudo registrar el pedido.',
      );
    }

    final pedido = datos['pedido'];

    if (pedido is! Map || pedido['id'] == null) {
      throw Exception('El servidor no devolvió el identificador del pedido.');
    }

    return (pedido['id'] as num).toInt();
  }

  Future<void> subirComprobante({
    required int pedidoId,
    required XFile imagen,
  }) async {
    final token = await UserService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Tu sesión ha expirado. Inicia sesión nuevamente.');
    }

    final extension = imagen.name.split('.').last.toLowerCase();
    final subtipo = extension == 'png' ? 'png' : 'jpeg';

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}/api/pedidos/$pedidoId/comprobante'),
    );

    // No poner Content-Type a mano: MultipartRequest lo genera con el boundary.
    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(
      http.MultipartFile.fromBytes(
        'comprobante', // debe coincidir con upload.single('comprobante')
        await imagen.readAsBytes(),
        filename: imagen.name,
        contentType: MediaType('image', subtipo),
      ),
    );

    final streamed = await request.send();
    final respuesta = await http.Response.fromStream(streamed);

    if (respuesta.statusCode != 200 && respuesta.statusCode != 201) {
      String mensaje = 'No se pudo subir el comprobante.';
      try {
        final datos = jsonDecode(respuesta.body);
        mensaje = datos['error'] ?? datos['message'] ?? mensaje;
      } catch (_) {}
      throw Exception(mensaje);
    }
  }
}
