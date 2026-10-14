import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';

// Fila del login: casilla "Recordarme" y enlace "¿Olvidaste Contraseña?"
class FilaRecordar extends StatelessWidget {
  final bool recordar;
  final ValueChanged<bool> onCambio;
  final VoidCallback onOlvido;

  const FilaRecordar({
    super.key,
    required this.recordar,
    required this.onCambio,
    required this.onOlvido,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: recordar, onChanged: (v) => onCambio(v ?? false)),
        Text(
          texto('recordarme'),
          style: const TextStyle(color: AppColors.goldSand),
        ),
        const Spacer(),
        TextButton(
          onPressed: onOlvido,
          child: Text(
            texto('olvidaste_contrasena'),
            style: const TextStyle(color: AppColors.goldSand),
          ),
        ),
      ],
    );
  }
}