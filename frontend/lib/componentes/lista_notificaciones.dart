import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/componentes/mensaje_notificaciones.dart';
import 'package:asadero/componentes/tarjeta_notificacion.dart';

// Lo que va debajo del título de Notificaciones: cargando, error, vacío o la lista
class ListaNotificaciones extends StatelessWidget {
  final bool cargando;
  final String? error;
  final List<Map<String, dynamic>> notificaciones;
  final VoidCallback onReintentar;
  final ValueChanged<Map<String, dynamic>> onAbrir;

  const ListaNotificaciones({
    super.key,
    required this.cargando,
    required this.error,
    required this.notificaciones,
    required this.onReintentar,
    required this.onAbrir,
  });

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Padding(
        padding: EdgeInsets.all(30),
        child: Center(child: CircularProgressIndicator(color: AppColors.earthBrown)),
      );
    }

    if (error != null) {
      return MensajeNotificaciones(
        icono: Icons.error_outline,
        mensaje: error!,
        textoBoton: texto('reintentar'),
        onBoton: onReintentar,
      );
    }

    if (notificaciones.isEmpty) {
      return MensajeNotificaciones(
        icono: Icons.notifications_none,
        mensaje: texto('sin_notificaciones'),
      );
    }

    return Column(
      children: [
        for (final n in notificaciones)
          TarjetaNotificacion(notificacion: n, onTap: () => onAbrir(n)),
      ],
    );
  }
}