import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

// Fondo en degradado (crema a rojo), el mismo del Home, para las pantallas nuevas
class FondoDegradado extends StatelessWidget {
  final Widget child;

  const FondoDegradado({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.goldSand, AppColors.redPrayerFlag],
        ),
      ),
      child: child,
    );
  }
}