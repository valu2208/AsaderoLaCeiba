import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/barra_navegacion.dart';
import 'package:asadero/componentes/boton_principal.dart';
import 'package:asadero/pantallas/nueva_contrasena.dart';

class Verificacion extends StatelessWidget {
  const Verificacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.asphalt,
              AppColors.redPrayerFlag,
              AppColors.goldSand,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const BarraNavegacion(),
                const SizedBox(height: 25),
                Text(
                  'Verificar el código de recuperación',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.kronaOne(
                    color: AppColors.goldSand,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 15),
                const Icon(
                  Icons.email,
                  color: AppColors.goldSand,
                  size: 75,
                ),
                const SizedBox(height: 40),
                Text(
                  'Ingresa el código de verificación',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.josefinSans(
                    color: AppColors.goldSand,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    5,
                    (index) => SizedBox(
                      width: 50,
                      height: 55,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: const TextStyle(
                          color: AppColors.asphalt,
                          fontSize: 22,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: AppColors.goldSand,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 45),
                BotonPrincipal(
                  texto: 'Verificar y Proceder',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NuevaContrasena(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),

                BotonPrincipal(texto: 'Reenviar código', onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
