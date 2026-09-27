import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/pantallas/carrito.dart';

class DetalleProducto extends StatelessWidget {
  final String nombre;
  final String precio;
  final String? imagen;
  final String? descripcion;
  final IconData? icono;

  const DetalleProducto({
    super.key,
    required this.nombre,
    required this.precio,
    this.imagen,
    this.descripcion,
    this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldSand,
      appBar: AppBar(
        backgroundColor: AppColors.goldSand,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.redPrayerFlag,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Lo más pedido',
          style: TextStyle(
            color: AppColors.asphalt,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.earthBrown,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          nombre,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.goldSand,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _imagenProducto(),
                        const SizedBox(height: 20),
                        Text(
                          descripcion ??
                              'Delicioso producto preparado especialmente para ti.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          precio,
                          style: const TextStyle(
                            color: AppColors.redPrayerFlag,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _botonCarrito(context),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _imagenProducto() {
    if (imagen != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset(
          imagen!,
          width: double.infinity,
          height: 230,
          fit: BoxFit.cover,
        ),
      );
    }

    return Icon(
      icono ?? Icons.restaurant,
      size: 150,
      color: AppColors.goldSand,
    );
  }

  Widget _botonCarrito(BuildContext context) {
    return SizedBox(
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
          padding: const EdgeInsets.symmetric(vertical: 15),
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
    );
  }
}