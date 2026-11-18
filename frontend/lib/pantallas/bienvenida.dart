
import 'package:flutter/material.dart';
import 'package:asadero/pantallas/inicio.dart';
import 'package:asadero/pantallas/idiomas.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/componentes/pollo_animado.dart';
import 'package:asadero/componentes/pulsante.dart';
import 'package:asadero/componentes/texto_ovalado.dart';
import 'package:google_fonts/google_fonts.dart';

class Bienvenida extends StatefulWidget {
  const Bienvenida({super.key});

  @override
  State<Bienvenida> createState() => _BienvenidaState();
}

class _BienvenidaState extends State<Bienvenida> with SingleTickerProviderStateMixin {
  late final AnimationController _entrada = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 5200),
  );

  late final Animation<double> _logo = CurvedAnimation(
    parent: _entrada,
    curve: const Interval(0.0, 0.2, curve: Curves.elasticOut),
  );

  late final Animation<double> _letras = CurvedAnimation(
    parent: _entrada,
    curve: const Interval(0.22, 0.8),
  );

  late final Animation<double> _boton = CurvedAnimation(
    parent: _entrada,
    curve: const Interval(0.84, 1.0, curve: Curves.easeIn),
  );

  @override
  void initState() {
    super.initState();
    _entrada.forward();
  }

  @override
  void reassemble() {
    super.reassemble();
    _entrada.forward(from: 0);
  }

  @override
  void dispose() {
    _entrada.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              AppColors.goldSand,
              AppColors.redPrayerFlag,
              AppColors.demonicPresence,
              AppColors.earthBrown,
              AppColors.asphalt,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(top: 5, right: 10, child: _botonIdioma()),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaleTransition(
                      scale: _logo,
                      child: SizedBox(
                        width: 390,
                        height: 390,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              size: const Size(390, 390),
                              painter: TextoOvaladoPainter(_letras),
                            ),
                            const PolloAnimado(tamano: 300),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    FadeTransition(
                      opacity: _boton,
                      child: Pulsante(hijo: _botonEntrar()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _botonIdioma() {
    return TextButton(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Idiomas()),
        );
        setState(() {});
      },
      child: Text(
        texto('cambiar_idioma'),
        style: GoogleFonts.inter(color: AppColors.goldSand, fontSize: 14),
      ),
    );
  }

  Widget _botonEntrar() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Inicio()),
        );
      },
      child: Text(
        texto('haz_click_aqui'),
        style: GoogleFonts.inter(
          color: AppColors.goldSand,
          fontSize: 25,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
