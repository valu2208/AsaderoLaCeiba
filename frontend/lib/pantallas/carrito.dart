import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/carrito_estado.dart';

class Carrito extends StatelessWidget {
  const Carrito({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CarritoItem>>(
      valueListenable: CarritoEstado.items,
      builder: (context, items, child) {
        return Scaffold(
          backgroundColor: AppColors.asphalt,
          appBar: AppBar(
            backgroundColor: AppColors.earthBrown,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.goldSand,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Carrito',
              style: TextStyle(color: AppColors.goldSand),
            ),
            centerTitle: true,
          ),
          body: items.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 80,
                          color: AppColors.goldSand,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Tu carrito está vacío',
                          style: TextStyle(
                            color: AppColors.goldSand,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Agrega tus productos favoritos para verlos aquí.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Card(
                      color: AppColors.fondoComponentes,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item.imagen,
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          item.nombre,
                          style: const TextStyle(
                            color: AppColors.goldSand,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${item.precio}\nCantidad: ${item.cantidad}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                          tooltip: 'Eliminar producto',
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.goldSand,
                          ),
                          onPressed: () {
                            CarritoEstado.eliminar(item.nombre);
                          },
                        ),
                      ),
                    );
                  },
                ),
          bottomNavigationBar: items.isEmpty
              ? null
              : Container(
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
      },
    );
  }
}