import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

class Carrito extends StatelessWidget {
  final String nombre;
  final String precio;

  const Carrito({
    super.key,
    required this.nombre,
    required this.precio,
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
          'Carrito',
          style: TextStyle(
            color: AppColors.goldSand,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Card(
          color: AppColors.fondoComponentes,
          child: ListTile(
            title: Text(
              nombre,
              style: const TextStyle(
                color: AppColors.goldSand,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '\$$precio',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(15),
        color: AppColors.earthBrown,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.redPrayerFlag,
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            'Realizar pedido',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}