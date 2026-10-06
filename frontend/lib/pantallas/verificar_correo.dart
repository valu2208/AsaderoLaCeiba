import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/barra_navegacion.dart';
import 'package:asadero/componentes/boton_principal.dart';
import 'package:asadero/pantallas/login.dart';

class VerificarCorreo extends StatelessWidget {
  const VerificarCorreo({super.key});

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
                  'Verificando el Correo',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.kronaOne(
                    color: AppColors.goldSand,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 15),
                const Icon(Icons.email, color: AppColors.goldSand, size: 65),
                const SizedBox(height: 20),
                Text(
                  'Ingresa el código de verificación',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.josefinSans(
                    color: AppColors.goldSand,
                    fontSize: 23,
                  ),
                ),
                const SizedBox(height: 45),
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

                const SizedBox(height: 60),
                BotonPrincipal(
                  texto: 'Verificar y Proceder',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const Login()),
                    );
                  },
                ),
                const SizedBox(height: 20),

                BotonPrincipal(texto: 'Reenviar código', onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
