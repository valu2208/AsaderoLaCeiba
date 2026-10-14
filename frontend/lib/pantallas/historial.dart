import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/componentes/barra_nav_inferior.dart';
import 'package:asadero/componentes/burbuja_asistente.dart';
import 'package:asadero/componentes/tarjeta_pedido.dart';
import 'package:asadero/componentes/detalle_pedido.dart';
import 'package:asadero/pantallas/home.dart';
import 'package:asadero/pantallas/carrito.dart';
import 'package:asadero/pantallas/productos.dart';

class Historial extends StatelessWidget {
  const Historial({super.key});

  final List<Map<String, String>> pedidos = const [
    {
      'numero': 'Pedido #001',
      'fecha': '10 de octubre de 2026',
      'productos': 'Pollo asado completo x1',
      'total': '\$35.000',
      'estado': 'Entregado',
    },
    {
      'numero': 'Pedido #002',
      'fecha': '8 de octubre de 2026',
      'productos': 'Medio pollo asado x1',
      'total': '\$20.000',
      'estado': 'Entregado',
    },
    {
      'numero': 'Pedido #003',
      'fecha': '6 de octubre de 2026',
      'productos': 'Un cuarto de pollo x2',
      'total': '\$24.000',
      'estado': 'Cancelado',
    },
  ];

  String traducirEstado(String estado) {
    if (estado == 'Entregado') return texto('entregado');
    if (estado == 'Cancelado') return texto('cancelado');
    return estado;
  }

  String traducirProducto(String producto) {
    if (producto.contains('Pollo asado completo')) {
      return '${texto('pollo_completo')} x1';
    }
    if (producto.contains('Medio pollo asado')) {
      return '${texto('medio_pollo')} x1';
    }
    if (producto.contains('Un cuarto de pollo')) {
      return '${texto('cuarto_pollo')} x2';
    }
    return producto;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Idioma.seleccionado,
      builder: (context, idioma, child) {
        return Scaffold(
          backgroundColor: AppColors.goldSand,
          appBar: AppBar(
            backgroundColor: AppColors.asphalt,
            foregroundColor: AppColors.goldSand,
            title: Text(
              texto('mi_historial'),
              style: GoogleFonts.kronaOne(fontSize: 18),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.goldSand,
                  AppColors.redPrayerFlag,
                ],
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  texto('pedidos_anteriores'),
                  style: GoogleFonts.kronaOne(
                    fontSize: 17,
                    color: AppColors.earthBrown,
                  ),
                ),
                const SizedBox(height: 16),
                ...pedidos.map((pedido) {
                  final producto =
                      traducirProducto(pedido['productos']!);
                  final estado =
                      traducirEstado(pedido['estado']!);

                  return TarjetaPedido(
                    pedido: pedido,
                    producto: producto,
                    estado: estado,
                    onVerDetalle: () {
                      showDialog(
                        context: context,
                        builder: (_) => DetallePedido(
                          pedido: pedido,
                          producto: producto,
                          estado: estado,
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
          floatingActionButton: const BurbujaAsistente(),
          bottomNavigationBar: BarraNavegacionInferior(
            indiceActual: 3,
            onTap: (indice) {
              if (indice == 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Home(),
                  ),
                );
              } else if (indice == 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Productos(),
                  ),
                );
              } else if (indice == 4) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Carrito(),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}