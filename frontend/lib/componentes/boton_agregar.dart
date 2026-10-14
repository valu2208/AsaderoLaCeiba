import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

class BotonAgregar extends StatelessWidget {
  final int cantidad;
  final VoidCallback onAgregar;
  final VoidCallback? onRestar;

  const BotonAgregar({
    super.key,
    required this.cantidad,
    required this.onAgregar,
    this.onRestar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (cantidad > 0) ...[
          IconButton(
            onPressed: onRestar,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 30),
            icon: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: AppColors.redPrayerFlag,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.remove,
                color: AppColors.goldSand,
                size: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '$cantidad',
              style: const TextStyle(
                color: AppColors.goldSand,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        IconButton(
          onPressed: onAgregar,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 24, minHeight: 30),
          icon: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppColors.redPrayerFlag,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: AppColors.goldSand, size: 16),
          ),
        ),
      ],
    );
  }
}
