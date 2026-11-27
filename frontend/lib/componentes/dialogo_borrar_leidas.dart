import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';

// Pregunta si se borran las notificaciones leídas. Devuelve true si confirma.
Future<bool> confirmarBorrarLeidas(BuildContext context) async {
  final confirmar = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.asphalt,
      title: Text(
        texto('borrar_notificaciones'),
        style: const TextStyle(color: AppColors.goldSand),
      ),
      content: Text(
        texto('pregunta_borrar_notificaciones'),
        style: const TextStyle(color: AppColors.goldSand),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(texto('cancelar'), style: const TextStyle(color: AppColors.goldSand)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(texto('borrar_leidas'), style: const TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  return confirmar == true;
}