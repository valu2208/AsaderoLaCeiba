import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/componentes/barra_nav_inferior.dart';
import 'package:asadero/componentes/burbuja_asistente.dart';
import 'package:asadero/componentes/fondo_degradado.dart';
import 'package:asadero/componentes/tarjeta_opcion_menu.dart';
import 'package:asadero/pantallas/carrito.dart';
import 'package:asadero/pantallas/historial.dart';
import 'package:asadero/pantallas/home.dart';
import 'package:asadero/pantallas/menu_categoria.dart';
import 'package:asadero/pantallas/perfil.dart';

// Pantalla Menú: opciones de la carta.
class Productos extends StatelessWidget {
  const Productos({super.key});

  // Los valores de categoria se mantienen iguales a los de la base de datos.
  static const List<Map<String, dynamic>> _opciones = [
    {
      'claveTitulo': 'categoria_desayuno',
      'claveDescripcion': 'descripcion_desayuno',
      'categoria': 'desayuno',
      'imagen': 'assets/imagenes/menu_desayuno.jpg',
      'color': AppColors.redPrayerFlag,
      'porDia': true,
      'icono': Icons.free_breakfast,
    },
    {
      'claveTitulo': 'categoria_almuerzo',
      'claveDescripcion': 'descripcion_almuerzo',
      'categoria': 'almuerzo',
      'imagen': 'assets/imagenes/menu_almuerzo.jpg',
      'color': AppColors.demonicPresence,
      'porDia': true,
      'icono': Icons.lunch_dining,
    },
    {
      'claveTitulo': 'categoria_gaseosas',
      'claveDescripcion': 'descripcion_gaseosas',
      'categoria': 'gaseosas',
      'imagen': 'assets/imagenes/menu_gaseosas.jpg',
      'color': AppColors.earthBrown,
      'porDia': false,
      'icono': Icons.local_drink,
    },
    {
      'claveTitulo': 'categoria_fin_semana',
      'claveDescripcion': 'descripcion_fin_semana',
      'categoria': 'fin_de_semana',
      'imagen': 'assets/imagenes/menu_fin_de_semana.jpg',
      'color': AppColors.asphalt,
      'porDia': false,
      'icono': Icons.celebration,
    },
  ];

  void _ir(BuildContext context, Widget pantalla) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => pantalla),
    );
  }

  // Regresa al Home.
  void _volver(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      _ir(context, const Home());
    }
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
              texto('menu'),
              style: GoogleFonts.kronaOne(fontSize: 18),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _volver(context),
            ),
          ),
          body: FondoDegradado(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 90),
              child: Column(
                children: [
                  for (final opcion in _opciones)
                    Expanded(
                      child: TarjetaOpcionMenu(
                        titulo: texto(opcion['claveTitulo'] as String),
                        descripcion: texto(
                          opcion['claveDescripcion'] as String,
                        ),
                        imagen: opcion['imagen'] as String,
                        icono: opcion['icono'] as IconData,
                        color: opcion['color'] as Color,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MenuCategoria(
                              titulo: texto(opcion['claveTitulo'] as String),
                              categoria: opcion['categoria'] as String,
                              porDia: opcion['porDia'] as bool,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          floatingActionButton: const BurbujaAsistente(),
          bottomNavigationBar: BarraNavegacionInferior(
            indiceActual: 2,
            onTap: (indice) {
              if (indice == 0) _ir(context, const Home());
              if (indice == 1) _ir(context, const Perfil());
              if (indice == 3) _ir(context, const Historial());
              if (indice == 4) _ir(context, const Carrito());
            },
          ),
        );
      },
    );
  }
}
