import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';

// Línea "O Continuar Con" que separa el login normal del de Google
class SeparadorContinuar extends StatelessWidget {
  const SeparadorContinuar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.goldSand)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            texto('continuar_con'),
            style: const TextStyle(color: AppColors.goldSand),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.goldSand)),
      ],
    );
  }
}