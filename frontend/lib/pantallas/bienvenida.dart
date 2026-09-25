import 'package:flutter/material.dart';
import 'package:asadero/pantallas/inicio.dart';
import 'package:asadero/core/colores.dart';
import 'package:google_fonts/google_fonts.dart';

class Bienvenida extends StatelessWidget {
  const Bienvenida({super.key});

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/imagenes/logo_ceiba.jpeg',
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 5),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Inicio()),
                  );
                },
                child: Text(
                  '¡haz click aquí!',
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
      ),
    );
  }
}
