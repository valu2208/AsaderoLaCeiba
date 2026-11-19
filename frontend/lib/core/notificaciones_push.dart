import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:asadero/services/api_config.dart';
import 'package:asadero/services/user_service.dart';

// Notificaciones push: permiso, canal, aviso con la app abierta
// y registro del token del celular en el backend.
class NotificacionesPush {
  static final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  // El id debe ser el mismo que usa el backend en utils/push.js
  static const AndroidNotificationChannel _canal = AndroidNotificationChannel(
    'high_importance_channel',
    'Avisos del asadero',
    description: 'Pedidos, estados y alertas de stock',
    importance: Importance.high,
  );

  static bool _iniciado = false;

  static Future<void> iniciar() async {
    if (_iniciado) return;
    _iniciado = true;

    try {
      await Firebase.initializeApp();

      await _local.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/launcher_icon'),
        ),
      );

      await _local
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_canal);

      await FirebaseMessaging.instance.requestPermission();

      FirebaseMessaging.onMessage.listen(_mostrarConAppAbierta);
      FirebaseMessaging.instance.onTokenRefresh.listen(_enviarToken);

      await registrarToken();
    } catch (error) {
      debugPrint('No se pudo iniciar las notificaciones push: $error');
    }
  }

  // Con la app abierta Android no muestra la push solo: la mostramos nosotros.
  static Future<void> _mostrarConAppAbierta(RemoteMessage mensaje) async {
    final aviso = mensaje.notification;
    if (aviso == null) return;

    await _local.show(
      id: mensaje.hashCode,
      title: aviso.title,
      body: aviso.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _canal.id,
          _canal.name,
          channelDescription: _canal.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/launcher_icon',
        ),
      ),
    );
  }

  // Manda el token de este celular al backend (si hay sesión iniciada).
  static Future<void> registrarToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) await _enviarToken(token);
    } catch (error) {
      debugPrint('No se pudo registrar el token: $error');
    }
  }

  static Future<void> _enviarToken(String tokenFcm) async {
    try {
      final jwt = await UserService.getToken();
      if (jwt == null || jwt.isEmpty) return;

      await http.post(
        Uri.parse('${ApiConfig.baseUrl}/dispositivos'),
        headers: {...ApiConfig.headers, 'Authorization': 'Bearer $jwt'},
        body: jsonEncode({'token': tokenFcm}),
      );
    } catch (error) {
      debugPrint('No se pudo enviar el token: $error');
    }
  }

  // Al cerrar sesión: el celular deja de recibir los avisos de ese usuario.
  static Future<void> quitarToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jwt = prefs.getString('jwt_token');
      final tokenFcm = await FirebaseMessaging.instance.getToken();

      if (jwt != null && jwt.isNotEmpty && tokenFcm != null) {
        await http
            .delete(
              Uri.parse('${ApiConfig.baseUrl}/dispositivos'),
              headers: {...ApiConfig.headers, 'Authorization': 'Bearer $jwt'},
              body: jsonEncode({'token': tokenFcm}),
            )
            .timeout(const Duration(seconds: 5));
      }

      await FirebaseMessaging.instance.deleteToken();
    } catch (error) {
      debugPrint('No se pudo quitar el token: $error');
    }
  }
}