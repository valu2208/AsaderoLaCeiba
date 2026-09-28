import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/boton_principal.dart';
import 'package:asadero/pantallas/login.dart';
import 'package:asadero/pantallas/registro.dart';

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
              Text(
                'Tu próxima gran idea empieza aquí! 💫',
                textAlign: TextAlign.center,
                style: GoogleFonts.kronaOne(
                  color: AppColors.goldSand,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Crea tu cuenta en 30 segundos y descubre todo lo que tenemos para ti',
                textAlign: TextAlign.center,
                style: GoogleFonts.kronaOne(
                  color: AppColors.goldSand,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              BotonPrincipal(
                texto: 'Comenzar ahora',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Registro()),
                  );
                },
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Login()),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(color: AppColors.goldSand, fontSize: 16),
                    children: [
                      TextSpan(text: '¿Ya tiene cuenta? '),
                      TextSpan(
                        text: 'Inicia Sesión',
                        style: TextStyle(
                          color: AppColors.goldSand,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
