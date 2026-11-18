import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';

class CarritoVacio extends StatelessWidget {
  const CarritoVacio({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_cart_outlined,
                size: 80, color: AppColors.goldSand),
            const SizedBox(height: 20),
            Text(
              texto('carrito_vacio'),
              style: const TextStyle(
                color: AppColors.goldSand,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              texto('agrega_favoritos'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}