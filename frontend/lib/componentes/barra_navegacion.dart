
import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

class BarraNavegacion extends StatelessWidget {
  const BarraNavegacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

