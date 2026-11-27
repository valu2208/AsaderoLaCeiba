import 'dart:async';

import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/core/modo_admin.dart';
import 'package:asadero/componentes/boton_volver_panel.dart';
import 'package:asadero/componentes/fila_usuario_home.dart';
import 'package:asadero/componentes/icono_notificaciones.dart';
import 'package:asadero/pantallas/historial_chat.dart';
import 'package:asadero/services/user_service.dart';
import 'package:asadero/services/notificaciones_service.dart';
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
      final cantidad = await NotificacionesService.contarNoLeidas();

      if (mounted && cantidad != null && cantidad != notificacionesNoLeidas) {
        setState(() {
          notificacionesNoLeidas = cantidad;
        });
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

  Future<void> _abrirHistorial() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HistorialChat()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Idioma.seleccionado,
      builder: (context, idioma, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: ModoAdmin.viendoCliente,
          builder: (context, viendo, child) => _encabezado(viendo),
        );
      },
    );
  }

  Widget _encabezado(bool viendoCliente) {
    final usuario = FilaUsuarioHome(nombre: nombre, avatar: avatar);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.asphalt,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            children: [
              // El admin viendo la carta: arriba va "Volver al panel" y el
              // saludo baja al segundo renglón
              _fila(viendoCliente ? const BotonVolverPanel() : usuario),
              if (viendoCliente) ...[
                const SizedBox(height: 16),
                usuario,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _fila(Widget izquierda) {
    return Row(
      children: [
        Expanded(child: izquierda),
        IconoNotificaciones(
          cantidad: notificacionesNoLeidas,
          onPressed: _abrirNotificaciones,
        ),
        IconButton(
          onPressed: _abrirHistorial,
          icon: const Icon(
            Icons.chat_bubble_outline,
            color: AppColors.goldSand,
          ),
        ),
      ],
    );
  }
}