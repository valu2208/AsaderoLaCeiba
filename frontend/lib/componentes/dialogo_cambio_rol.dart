import 'package:flutter/material.dart';
import 'package:asadero/core/roles.dart';
import 'package:asadero/models/user_model.dart';

// Pregunta al admin si está seguro de cambiar el rol; devuelve true si confirma
Future<bool> confirmarCambioRol(
  BuildContext context,
  UserModel usuario,
  String nuevoRol,
) async {
  final confirmar = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Cambiar rol'),
      content: Text(
        '¿Cambiar a ${usuario.nombre} de ${nombreRol(usuario.rol)} a ${nombreRol(nuevoRol)}?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Cambiar'),
        ),
      ],
    ),
  );
  return confirmar == true;
}
