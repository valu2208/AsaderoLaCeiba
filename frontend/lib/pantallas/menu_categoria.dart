import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/burbuja_asistente.dart';
import 'package:asadero/componentes/carta_productos.dart';
import 'package:asadero/core/dias_semana.dart';
import 'package:asadero/componentes/fondo_degradado.dart';
import 'package:asadero/pantallas/carrito.dart';
import 'package:asadero/services/producto_service.dart';

// Platos de una opción del Menú: se ven igual que "Lo más pedido"
// (más información, cantidad y agregar al carrito)
class MenuCategoria extends StatelessWidget {
  final String titulo;
  final String categoria; // desayuno, almuerzo, gaseosas o fin_de_semana
  final bool porDia; // true = solo muestra los platos de hoy

  const MenuCategoria({
    super.key,
    required this.titulo,
    required this.categoria,
    this.porDia = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldSand,
      appBar: AppBar(
        backgroundColor: AppColors.asphalt,
        foregroundColor: AppColors.goldSand,
        title: Text(titulo, style: GoogleFonts.kronaOne(fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Carrito()),
            ),
          ),
        ],
      ),
      body: FondoDegradado(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CartaProductos(
                columnas: 1,
                cargar: () => ProductoService().obtenerPorCategoria(
                  categoria,
                  dia: porDia ? diaDeHoy() : null,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const BurbujaAsistente(),
    );
  }
}