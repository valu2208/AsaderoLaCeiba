import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

class BarraNavegacion extends StatelessWidget {
  const BarraNavegacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.goldSand,
            size: 28,
          ),
        ),
      ],
    );
  }
}
