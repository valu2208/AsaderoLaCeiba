import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

class BotonAgregar extends StatelessWidget {
  final int cantidad;
  final VoidCallback onAgregar;

  const BotonAgregar({
    super.key,
    required this.cantidad,
    required this.onAgregar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (cantidad > 0)
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Text(
              '$cantidad',
              style: const TextStyle(
                color: AppColors.goldSand,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        IconButton(
          onPressed: onAgregar,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppColors.redPrayerFlag,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: AppColors.goldSand,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }
}