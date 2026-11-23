import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/pantallas/bienvenida.dart';

class BarraNavegacion extends StatelessWidget {
  const BarraNavegacion({super.key});

  // Si hay pantalla anterior vuelve; si no (login abierto sin historial),
  // va a la pantalla de bienvenida en vez de quedarse en negro.
  void _volver(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Bienvenida()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => _volver(context),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.goldSand,
            size: 28,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 12),
          child: Text(
            'Asadero La Ceiba',
            style: TextStyle(
              color: AppColors.goldSand,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}


