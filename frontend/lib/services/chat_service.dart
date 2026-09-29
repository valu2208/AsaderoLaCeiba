import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:asadero/services/api_config.dart';
import 'package:flutter/foundation.dart';

class RespuestaChat {
  final String texto;
  final String? sesionId;

  const RespuestaChat({required this.texto, this.sesionId});
}

class ChatService {
  static String get _chatUrl => '${ApiConfig.baseUrl}/chat/mensaje';

  static Future<RespuestaChat> enviarMensaje(
    String mensaje, {
    String? sesionId,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(_chatUrl),
            headers: ApiConfig.headers,
            body: jsonEncode({
              'mensaje': mensaje,
              if (sesionId != null) 'sesion_id': sesionId,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return RespuestaChat(
          texto: data['mensaje'] ?? 'No se recibió respuesta.',
          sesionId: data['sesion_id'],
        );
      }

      return RespuestaChat(
        texto: 'En este momento no pudimos procesar tu solicitud.',
        sesionId: sesionId,
      );
    } catch (e) {
      debugPrint('Error en ChatService: $e');
      return RespuestaChat(
        texto: 'No hay conexión con el asadero. Revisa que el servidor esté encendido.',
        sesionId: sesionId,
      );
    }
  }
}