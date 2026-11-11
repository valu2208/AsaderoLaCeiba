import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/pantallas/chat.dart';
import 'package:asadero/services/user_service.dart';
import 'package:asadero/services/api_config.dart';
import 'package:asadero/pantallas/notificaciones.dart';

class EncabezadoHome extends StatefulWidget {
  const EncabezadoHome({super.key});

  @override
  State<EncabezadoHome> createState() => _EncabezadoHomeState();
}

class _EncabezadoHomeState extends State<EncabezadoHome> {
  String nombre = '';
  String? avatar;
  int notificacionesNoLeidas = 0;
  Timer? _temporizador;
  bool _consultando = false;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
    _cargarNoLeidas();

    _temporizador = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _cargarNoLeidas(),
    );
  }

  @override
  void dispose() {
    _temporizador?.cancel();
    super.dispose();
  }

  Future<void> _cargarUsuario() async {
    final String nombreUsuario = await UserService.getNombre();
    final String? fotoUsuario = await UserService.getAvatar();

    if (!mounted) return;

    setState(() {
      nombre = nombreUsuario.trim();
      avatar = (fotoUsuario != null && fotoUsuario.isNotEmpty)
          ? fotoUsuario
          : null;
    });
  }

  Future<void> _cargarNoLeidas() async {
    if (_consultando) return;
    _consultando = true;

    try {
      final token = await UserService.getToken();

      if (token == null || token.isEmpty) return;

      final respuesta = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/notificaciones/no-leidas'),
        headers: {...ApiConfig.headers, 'Authorization': 'Bearer $token'},
      );

      if (respuesta.statusCode == 200) {
        final datos = jsonDecode(respuesta.body);
        final cantidad = int.tryParse('${datos['no_leidas']}') ?? 0;

        if (mounted && cantidad != notificacionesNoLeidas) {
          setState(() {
            notificacionesNoLeidas = cantidad;
          });
        }
      }
    } catch (e) {
      debugPrint('Error al consultar notificaciones: $e');
    } finally {
      _consultando = false;
    }
  }

  Future<void> _abrirNotificaciones() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Notificaciones()),
    );

    _cargarNoLeidas();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Idioma.seleccionado,
      builder: (context, idioma, child) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.asphalt,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Column(
                children: [
                  _fila(context),
                  const SizedBox(height: 16),
                  _buscador(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _fila(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.earthBrown,
          backgroundImage: avatar != null && avatar!.isNotEmpty
              ? NetworkImage(avatar!)
              : null,
          child: avatar == null || avatar!.isEmpty
              ? const Icon(Icons.person, color: AppColors.goldSand, size: 20)
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            nombre.isEmpty
                ? texto('bienvenido_usuario')
                : '¡Bienvenid@, $nombre!',
            style: GoogleFonts.kronaOne(
              color: AppColors.goldSand,
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          onPressed: _abrirNotificaciones,
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_none, color: AppColors.goldSand),
              if (notificacionesNoLeidas > 0)
                Positioned(
                  top: -7,
                  right: -7,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 17,
                      minHeight: 17,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.redPrayerFlag,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      notificacionesNoLeidas > 99
                          ? '99+'
                          : '$notificacionesNoLeidas',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: AppColors.asphalt,
              builder: (_) => const Chat(),
            );
          },
          icon: const Icon(
            Icons.chat_bubble_outline,
            color: AppColors.goldSand,
          ),
        ),
      ],
    );
  }

  Widget _buscador() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: texto('buscar'),
        hintStyle: TextStyle(color: AppColors.goldSand.withValues(alpha: 0.7)),
        prefixIcon: const Icon(Icons.search, color: AppColors.redPrayerFlag),
        filled: true,
        fillColor: AppColors.earthBrown,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
