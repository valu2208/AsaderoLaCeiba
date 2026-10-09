import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/componentes/barra_navegacion.dart';
import 'package:asadero/componentes/boton_principal.dart';
import 'package:asadero/pantallas/login.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.asphalt,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const BarraNavegacion(),
<<<<<<< Updated upstream
              const SizedBox(height: 100),
=======
              const SizedBox(height: 65),

>>>>>>> Stashed changes
              Text(
                texto('tu_proxima_gran_idea'),
                textAlign: TextAlign.center,
                style: GoogleFonts.kronaOne(
                  color: AppColors.goldSand,
                  fontSize: 25,
                ),
              ),
<<<<<<< Updated upstream
              const SizedBox(height: 95),
=======
              const SizedBox(height: 80),

>>>>>>> Stashed changes
              Text(
                texto('mensaje_inicio'),
                textAlign: TextAlign.center,
                style: GoogleFonts.kronaOne(
                  color: AppColors.goldSand,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              BotonPrincipal(
                texto: texto('comenzar'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Login()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
