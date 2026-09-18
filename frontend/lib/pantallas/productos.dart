import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/pantallas/detalle_producto.dart';

class Productos extends StatelessWidget {
  const Productos({super.key});

  final productos = const [
    ['Pollo Asado', '30000', Icons.restaurant],
    ['Bandeja Paisa', '25000', Icons.lunch_dining],
    ['Huevos con Salchicha', '12000', Icons.egg],
    ['Crema de Auyama', '10000', Icons.soup_kitchen],
    ['Jugo de Mora', '7000', Icons.local_drink],
    ['Lentejas', '12000', Icons.ramen_dining],
  ];

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
          'Menú',
          style: TextStyle(
            color: AppColors.goldSand,
          ),
        ),
        centerTitle: true,
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: productos.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          return Card(
            color: AppColors.fondoComponentes,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalleProducto(
                      nombre: productos[index][0] as String,
                      precio: productos[index][1] as String,
                      icono: productos[index][2] as IconData,
                    ),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    productos[index][2] as IconData,
                    size: 55,
                    color: AppColors.goldSand,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    productos[index][0] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.goldSand,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '\$${productos[index][1]}',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}