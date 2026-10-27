import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

// Botón principal de los formularios del admin (muestra una ruedita al guardar)
class BotonFormulario extends StatelessWidget {
  final String texto;
  final bool cargando;
  final VoidCallback onPressed;

  const BotonFormulario({
    super.key,
    required this.texto,
    required this.cargando,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.redPrayerFlag,
          foregroundColor: AppColors.goldSand,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: cargando ? null : onPressed,
        child: cargando
            ? const CircularProgressIndicator(color: AppColors.goldSand)
            : Text(texto),
      ),
    );
  }
}