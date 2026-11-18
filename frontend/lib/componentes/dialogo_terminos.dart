import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';

Future<void> mostrarTerminos(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppColors.asphalt,
      title: Text(
        texto('terminos_titulo'),
        style: const TextStyle(color: AppColors.goldSand),
      ),
      content: SingleChildScrollView(
        child: Text(
          texto('terminos_texto'),
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(texto('cerrar'),
              style: const TextStyle(color: AppColors.goldSand)),
        ),
      ],
    ),
  );
}