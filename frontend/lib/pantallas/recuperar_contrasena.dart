import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/barra_navegacion.dart';
import 'package:asadero/componentes/campo_texto.dart';
import 'package:asadero/componentes/boton_principal.dart';
import 'package:asadero/pantallas/verificacion.dart';

class RecuperarContrasena extends StatelessWidget {
  const RecuperarContrasena({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.asphalt,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const BarraNavegacion(),
              const SizedBox(height: 20),
              const Icon(
                Icons.key,
                color: AppColors.goldSand,
                size: 95,
              ),
              const SizedBox(height: 30),
              Text(
                'Recuperar Contraseña',
                textAlign: TextAlign.center,
                style: GoogleFonts.kronaOne(
                  color: AppColors.goldSand,
                  fontSize: 23,
                ),
              ),
              const SizedBox(height: 55),
              const CampoTexto(
                texto: 'Correo Electrónico',
                icono: Icons.email,
              ),
              const SizedBox(height: 18),
              const CampoTexto(
                texto: 'Teléfono',
                icono: Icons.phone,
              ),
              const SizedBox(height: 68),
              BotonPrincipal(
                texto: 'Recuperar contraseña',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const Verificacion(),
                    ),
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