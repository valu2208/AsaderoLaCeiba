import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';

// Pregunta si de verdad quiere cerrar sesión. Devuelve true si confirma.
Future<bool> confirmarCerrarSesion(BuildContext context) async {
  final salir = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.asphalt,
      title: Text(
        texto('cerrar_sesion'),
        style: const TextStyle(color: AppColors.goldSand),
      ),
      content: Text(
        texto('pregunta_cerrar_sesion'),
        style: const TextStyle(color: AppColors.goldSand),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(texto('cancelar'), style: const TextStyle(color: AppColors.goldSand)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(texto('salir'), style: const TextStyle(color: AppColors.redPrayerFlag)),
        ),
      ],
    ),
  );

  return salir == true;
}