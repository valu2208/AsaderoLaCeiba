import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/burbuja_asistente.dart';
import 'package:asadero/componentes/encabezado_home.dart';
import 'package:asadero/componentes/lista_productos.dart';
import 'package:asadero/componentes/barra_nav_inferior.dart';
import 'package:asadero/pantallas/chat.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  final List<Map<String, String>> productos = const [
    {
      'nombre': 'Pollo Asado completo',
      'precio': '\$35.000',
      'imagen': 'assets/imagenes/pollo_completo.jpg',
      'descripcion':
          'Delicioso pollo asado, jugoso por dentro y crocante por fuera.',
    },
    {
      'nombre': 'Medio Pollo Asado',
      'precio': '\$20.000',
      'imagen': 'assets/imagenes/medio_pollo.jpg',
      'descripcion':
          'Media porción de pollo asado acompañada con papas y arepa.',
    },
    {
      'nombre': 'Un Cuarto de Pollo Asado',
      'precio': '\$12.000',
      'imagen': 'assets/imagenes/uncuarto_pollo.avif',
      'descripcion':
          'Porción individual de pollo asado con papa, arepa y ensalada fresca.',
    },
  ];

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
          if (indice == 4) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: AppColors.asphalt,
              builder: (_) => const Chat(),
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
            ListaProductos(productos: productos),
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
