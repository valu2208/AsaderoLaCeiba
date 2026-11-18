import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/core/transicion.dart';
import 'package:asadero/models/opcion_menu.dart';
import 'package:asadero/componentes/barra_nav_inferior.dart';
import 'package:asadero/componentes/burbuja_asistente.dart';
import 'package:asadero/componentes/fondo_degradado.dart';
import 'package:asadero/componentes/tarjeta_opcion_menu.dart';
import 'package:asadero/pantallas/carrito.dart';
import 'package:asadero/pantallas/historial.dart';
import 'package:asadero/pantallas/home.dart';
import 'package:asadero/pantallas/menu_categoria.dart';
import 'package:asadero/pantallas/perfil.dart';
import 'package:asadero/pantallas/login.dart';
import 'package:asadero/services/user_service.dart';

// Pantalla Menú (botón del centro de la barra): las opciones de la carta
class Productos extends StatelessWidget {
  const Productos({super.key});

  static List<OpcionMenu> _opciones() => [
    OpcionMenu(
      titulo: texto('menu_desayuno_titulo'),
      categoria: 'desayuno',
      descripcion: texto('menu_desayuno_descripcion'),
      imagen: 'assets/imagenes/menu_desayuno.jpg',
      icono: Icons.free_breakfast,
      color: const Color(0xFFD9611A),
      colorFin: const Color(0xFFA92A0A),
      porDia: true,
    ),
    OpcionMenu(
      titulo: texto('menu_almuerzo_titulo'),
      categoria: 'almuerzo',
      descripcion: texto('menu_almuerzo_descripcion'),
      imagen: 'assets/imagenes/menu_almuerzo.jpg',
      icono: Icons.lunch_dining,
      color: const Color(0xFFC41E14),
      colorFin: const Color(0xFF7B1103),
      porDia: true,
    ),
    OpcionMenu(
      titulo: texto('menu_gaseosas_titulo'),
      categoria: 'gaseosas',
      descripcion: texto('menu_gaseosas_descripcion'),
      imagen: 'assets/imagenes/menu_gaseosas.jpg',
      icono: Icons.local_drink,
      color: const Color(0xFFA12A55),
      colorFin: const Color(0xFF5E1230),
    ),
    OpcionMenu(
      titulo: texto('menu_fin_semana_titulo'),
      categoria: 'fin_de_semana',
      descripcion: texto('menu_fin_semana_descripcion'),
      imagen: 'assets/imagenes/menu_fin_de_semana.jpg',
      icono: Icons.celebration,
      color: const Color(0xFF4A2312),
      colorFin: const Color(0xFF1C0A0A),
    ),
  ];

  void _ir(BuildContext context, Widget pantalla) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => pantalla),
    );
  }

  // Exigir sesión para entrar a Perfil o Historial.
  Future<void> _abrirZonaPrivada(BuildContext context, Widget pantalla) async {
    final token = await UserService.getToken();

    if (!context.mounted) return;

    if (token == null || token.isEmpty) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
      );
      return;
    }

    _ir(context, pantalla);
  }

  // Flecha de volver: regresa al Home
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
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 90),
              child: Column(
                children: [
                  // Cada opción ocupa la misma parte de la pantalla
                  for (final opcion in _opciones())
                    Expanded(
                      child: TarjetaOpcionMenu(
                        opcion: opcion,
                        onTap: () => Navigator.push(
                          context,
                          rutaSuave(MenuCategoria(opcion: opcion)),
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

              if (indice == 1) {
                _abrirZonaPrivada(context, Perfil());
              }

              if (indice == 3) {
                _abrirZonaPrivada(context, const Historial());
              }

              if (indice == 4) _ir(context, const Carrito());
            },
          ),
        );
      },
    );
  }
}
