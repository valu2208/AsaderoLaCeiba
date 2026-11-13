import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:asadero/services/api_config.dart';
import 'package:asadero/services/user_service.dart';

class RespuestaChat {
  final String texto;
  final String? sesionId;

  const RespuestaChat({required this.texto, this.sesionId});
}

class ConversacionChat {
  final String sesionId;
  final String titulo;
  final String ultimoMensaje;
  final DateTime? fecha;

  const ConversacionChat({
    required this.sesionId,
    required this.titulo,
    required this.ultimoMensaje,
    this.fecha,
  });

  factory ConversacionChat.fromJson(Map<String, dynamic> json) {
    return ConversacionChat(
      sesionId: json['sesion_id']?.toString() ?? '',
      titulo: json['titulo']?.toString() ?? 'Conversación',
      ultimoMensaje: json['ultimo_mensaje']?.toString() ?? '',
      fecha: DateTime.tryParse(json['fecha']?.toString() ?? ''),
    );
  }
}

class MensajeChat {
  final String emisor;
  final String mensaje;
  final DateTime? fecha;

  const MensajeChat({required this.emisor, required this.mensaje, this.fecha});

  bool get esUsuario => emisor == 'usuario';

  factory MensajeChat.fromJson(Map<String, dynamic> json) {
    return MensajeChat(
      emisor: json['emisor']?.toString() ?? '',
      mensaje: json['mensaje']?.toString() ?? '',
      fecha: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
}

class ChatService {
  static String get _chatUrl => '${ApiConfig.baseUrl}/chat';

  static String _mensajeError(String idioma, bool conexion) {
    if (idioma == 'English') {
      return conexion
          ? 'There is no connection to the restaurant. Check that the server is running.'
          : 'We could not process your request at this time.';
    }

    if (idioma == 'Português') {
      return conexion
          ? 'Não há conexão com o restaurante. Verifique se o servidor está ligado.'
          : 'Não foi possível processar sua solicitação neste momento.';
    }

    return conexion
        ? 'No hay conexión con el asadero. Revisa que el servidor esté encendido.'
        : 'En este momento no pudimos procesar tu solicitud.';
  }

  static Future<Map<String, String>> _headersAutenticados() async {
    final token = await UserService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Tu sesión ha expirado. Inicia sesión nuevamente.');
    }

    return {...ApiConfig.headers, 'Authorization': 'Bearer $token'};
  }

  static Future<RespuestaChat> enviarMensaje(
    String mensaje, {
    String? sesionId,
    String idioma = 'Español',
  }) async {
    try {
      final headers = await _headersAutenticados();

      final response = await http
          .post(
            Uri.parse('$_chatUrl/mensaje'),
            headers: headers,
            body: jsonEncode({
              'mensaje': mensaje,
              'idioma': idioma,
              if (sesionId != null) 'sesion_id': sesionId,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        return RespuestaChat(
          texto: data['mensaje']?.toString() ?? 'No se recibió respuesta.',
          sesionId: data['sesion_id']?.toString(),
        );
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        return RespuestaChat(
          texto: 'Tu sesión ha expirado. Inicia sesión nuevamente.',
          sesionId: sesionId,
        );
      }

      return RespuestaChat(
        texto: _mensajeError(idioma, false),
        sesionId: sesionId,
      );
    } catch (e) {
      debugPrint('Error en ChatService: $e');

      return RespuestaChat(
        texto: e.toString().contains('sesión')
            ? e.toString().replaceFirst('Exception: ', '')
            : _mensajeError(idioma, true),
        sesionId: sesionId,
      );
    }
  }

  // Consultar las conversaciones del usuario autenticado.
  static Future<List<ConversacionChat>> obtenerHistorial() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_chatUrl/historial'),
            headers: await _headersAutenticados(),
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) {
        throw Exception(_leerError(response));
      }

      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final lista = data['conversaciones'] as List? ?? [];

      return lista
          .map(
            (item) =>
                ConversacionChat.fromJson(Map<String, dynamic>.from(item)),
          )
          .where((item) => item.sesionId.isNotEmpty)
          .toList();
    } catch (e) {
      debugPrint('Error al obtener historial: $e');
      rethrow;
    }
  }

  // Consultar los mensajes de una conversación.
  static Future<List<MensajeChat>> obtenerMensajes(String sesionId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$_chatUrl/historial/${Uri.encodeComponent(sesionId)}'),
            headers: await _headersAutenticados(),
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) {
        throw Exception(_leerError(response));
      }

      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final lista = data['mensajes'] as List? ?? [];

      return lista
          .map((item) => MensajeChat.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (e) {
      debugPrint('Error al consultar conversación: $e');
      rethrow;
    }
  }

  // Eliminar una conversación del usuario autenticado.
  static Future<void> eliminarConversacion(String sesionId) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$_chatUrl/historial/${Uri.encodeComponent(sesionId)}'),
            headers: await _headersAutenticados(),
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) {
        throw Exception(_leerError(response));
      }
    } catch (e) {
      debugPrint('Error al eliminar conversación: $e');
      rethrow;
    }
  }

  static String _leerError(http.Response response) {
    try {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['error']?.toString() ?? 'No se pudo consultar el historial.';
    } catch (_) {
      return 'No se pudo consultar el historial (${response.statusCode}).';
    }
  }
}
