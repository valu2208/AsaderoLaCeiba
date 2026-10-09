import 'package:flutter/material.dart';
import 'package:asadero/pantallas/inicio.dart';
import 'package:asadero/pantallas/idiomas.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/idioma.dart';
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
                    ClipOval(
                      child: Image.asset(
                        'assets/imagenes/logo_ceiba.jpeg',
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 15),
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