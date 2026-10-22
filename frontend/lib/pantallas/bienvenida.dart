
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:asadero/pantallas/inicio.dart';
import 'package:asadero/pantallas/idiomas.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:google_fonts/google_fonts.dart';

class Bienvenida extends StatefulWidget {
  const Bienvenida({super.key});

  @override
  State<Bienvenida> createState() => _BienvenidaState();
}

class _BienvenidaState extends State<Bienvenida> {
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
              Positioned(
                top: 5,
                right: 10,
                child: TextButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Idiomas(),
                      ),
                    );
                    setState(() {});
                  },
                  child: Text(
                    'Cambio de idioma',
                    style: GoogleFonts.inter(
                      color: AppColors.goldSand,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 360,
                      height: 360,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(360, 360),
                            painter: TextoOvaladoPainter(),
                          ),
                          ClipOval(
                            child: Image.asset(
                              'assets/imagenes/logo_ceiba.jpeg',
                              width: 300,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const Inicio(),
                          ),
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
}

class TextoOvaladoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final ovalo = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width - 10,
      height: size.height - 10,
    );

    final arriba = Path()
      ..addArc(ovalo, math.pi, math.pi);

    final abajo = Path()
      ..addArc(ovalo, math.pi, -math.pi);

    const estilo = TextStyle(
      color: AppColors.goldSand,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
    );

    dibujarTexto(canvas, 'ASADERO', arriba, estilo);
    dibujarTexto(canvas, 'LA CEIBA', abajo, estilo);
  }

  void dibujarTexto(
    Canvas canvas,
    String texto,
    Path camino,
    TextStyle estilo,
  ) {
    final metricas = camino.computeMetrics().toList();

    if (metricas.isEmpty) return;

    final metrica = metricas.first;

    final letras = texto.split('').map((letra) {
      return TextPainter(
        text: TextSpan(
          text: letra,
          style: estilo,
        ),
        textDirection: TextDirection.ltr,
      )..layout();
    }).toList();

    final anchoTexto = letras.fold<double>(
      0,
      (total, letra) => total + letra.width,
    );

    double distancia = (metrica.length - anchoTexto) / 2;

    for (final letra in letras) {
      final posicion = distancia + letra.width / 2;

      final tangente = metrica.getTangentForOffset(
        posicion.clamp(0.0, metrica.length).toDouble(),
      );

      if (tangente != null) {
        canvas.save();
        canvas.translate(
          tangente.position.dx,
          tangente.position.dy,
        );
        canvas.rotate(tangente.angle);
        letra.paint(
          canvas,
          Offset(-letra.width / 2, -letra.height / 2),
        );
        canvas.restore();
      }

      distancia += letra.width;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

