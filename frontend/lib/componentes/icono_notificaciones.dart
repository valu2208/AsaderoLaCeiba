import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

// Campana del encabezado con el globito rojo de notificaciones sin leer
class IconoNotificaciones extends StatelessWidget {
  final int cantidad;
  final VoidCallback onPressed;

  const IconoNotificaciones({
    super.key,
    required this.cantidad,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.notifications_none, color: AppColors.goldSand),
          if (cantidad > 0)
            Positioned(
              top: -7,
              right: -7,
              child: Container(
                constraints: const BoxConstraints(minWidth: 17, minHeight: 17),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: const BoxDecoration(
                  color: AppColors.redPrayerFlag,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  cantidad > 99 ? '99+' : '$cantidad',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}