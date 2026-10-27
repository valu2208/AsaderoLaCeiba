import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/burbuja_asistente.dart';
import 'package:asadero/componentes/encabezado_home.dart';
import 'package:asadero/componentes/carta_productos.dart';
import 'package:asadero/componentes/barra_nav_inferior.dart';
import 'package:asadero/pantallas/historial.dart';
import 'package:asadero/pantallas/carrito.dart';
import 'package:asadero/pantallas/productos.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldSand,
      body: Column(
        children: [
          const EncabezadoHome(),
          Expanded(child: _contenido(context)),
        ],
      ),
      floatingActionButton: const BurbujaAsistente(),
      bottomNavigationBar: BarraNavegacionInferior(
        onTap: (indice) {
          if (indice == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Productos()),
            );
          } else if (indice == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Historial()),
            );
          } else if (indice == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Carrito()),
            );
          }
        },
      ),
    );
  }

  Widget _contenido(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.goldSand, AppColors.redPrayerFlag],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _titulo(),
            const SizedBox(height: 15),
            const CartaProductos(),
          ],
        ),
      ),
    );
  }

  Widget _titulo() {
    return Text(
      '¡Lo más pedido!',
      style: GoogleFonts.kronaOne(color: AppColors.earthBrown, fontSize: 22),
    );
  }
}