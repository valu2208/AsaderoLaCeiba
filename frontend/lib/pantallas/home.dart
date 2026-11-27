import 'package:flutter/material.dart';
import 'package:asadero/core/transicion.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/componentes/burbuja_asistente.dart';
import 'package:asadero/componentes/encabezado_home.dart';
import 'package:asadero/componentes/carta_productos.dart';
import 'package:asadero/componentes/barra_nav_inferior.dart';
import 'package:asadero/pantallas/historial.dart';
import 'package:asadero/pantallas/carrito.dart';
import 'package:asadero/pantallas/perfil.dart';
import 'package:asadero/pantallas/productos.dart';
import 'package:asadero/pantallas/login.dart';
import 'package:asadero/services/user_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _versionEncabezado = 0;

  Future<bool> _tieneSesion() async {
    final token = await UserService.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<bool> _exigirSesion() async {
    try {
      final tieneSesion = await _tieneSesion();

      if (!mounted) return false;

      if (tieneSesion) return true;

      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
      );

      return false;
    } catch (_) {
      if (!mounted) return false;

      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
      );

      return false;
    }
  }

  Future<void> _abrirPerfil() async {
    if (!await _exigirSesion()) return;

    if (!mounted) return;

    await Navigator.push(
      context,
      rutaInstantanea(const Perfil()),
    );

    if (!mounted) return;

    setState(() {
      _versionEncabezado++;
    });
  }

  Future<void> _abrirHistorial() async {
    if (!await _exigirSesion()) return;

    if (!mounted) return;

    Navigator.push(
      context,
      rutaInstantanea(const Historial()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldSand,
      body: Column(
        children: [
          EncabezadoHome(key: ValueKey(_versionEncabezado)),
          Expanded(child: _contenido(context)),
        ],
      ),
      floatingActionButton: const BurbujaAsistente(),
      bottomNavigationBar: BarraNavegacionInferior(
        onTap: (indice) {
          if (indice == 1) {
            _abrirPerfil();
          } else if (indice == 2) {
            Navigator.push(
              context,
              rutaInstantanea(const Productos()),
            );
          } else if (indice == 3) {
            _abrirHistorial();
          } else if (indice == 4) {
            Navigator.push(
              context,
              rutaInstantanea(const Carrito()),
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
    return ValueListenableBuilder<String>(
      valueListenable: Idioma.seleccionado,
      builder: (context, idioma, child) {
        return Text(
          texto('lo_mas_pedido'),
          style: GoogleFonts.kronaOne(
            color: AppColors.earthBrown,
            fontSize: 22,
          ),
        );
      },
    );
  }
}