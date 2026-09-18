import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/pantallas/carrito.dart';

class DetalleProducto extends StatelessWidget {
  final String nombre;
  final String precio;
  final IconData icono;

  const DetalleProducto({
    super.key,
    required this.nombre,
    required this.precio,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.asphalt,

      appBar: AppBar(
        backgroundColor: AppColors.earthBrown,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.goldSand,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Detalle del producto',
          style: TextStyle(
            color: AppColors.goldSand,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            Icon(
              icono,
              size: 130,
              color: AppColors.goldSand,
            ),

            const SizedBox(height: 30),

            Text(
              nombre,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.goldSand,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              '\$$precio',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Delicioso producto preparado especialmente para ti.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Carrito(
                        nombre: nombre,
                        precio: precio,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.redPrayerFlag,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Agregar al carrito',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}