import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/barra_navegacion.dart';
import 'package:asadero/componentes/campo_texto.dart';
import 'package:asadero/componentes/boton_principal.dart';
import 'package:asadero/pantallas/login.dart';

class NuevaContrasena extends StatefulWidget {
  const NuevaContrasena({super.key});

  @override
  State<NuevaContrasena> createState() => _NuevaContrasenaState();
}

class _NuevaContrasenaState extends State<NuevaContrasena> {
  bool mostrar = false;

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
                  'Restaurar Contraseña',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.kronaOne(
                    color: AppColors.goldSand,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 40),
                const Icon(
                  Icons.check_circle,
                  color: AppColors.goldSand,
                  size: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  'Escribir nueva contraseña',
                  style: GoogleFonts.kronaOne(
                    color: AppColors.goldSand,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 50),
                CampoTexto(
                  texto: 'Nueva contraseña',
                  icono: Icons.lock,
                  ocultar: !mostrar,
                  estiloNuevo: true,
                  onPressed: () => setState(() => mostrar = !mostrar),
                ),
                const SizedBox(height: 18),
                CampoTexto(
                  texto: 'Confirmar nueva contraseña',
                  icono: Icons.lock,
                  ocultar: !mostrar,
                  estiloNuevo: true,
                  onPressed: () => setState(() => mostrar = !mostrar),
                ),
                const SizedBox(height: 75),
                BotonPrincipal(
                  texto: 'Continuar',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Login(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}