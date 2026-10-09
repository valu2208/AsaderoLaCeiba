import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/componentes/barra_navegacion.dart';
import 'package:asadero/componentes/boton_principal.dart';
import 'package:asadero/pantallas/nueva_contrasena.dart';

class Verificacion extends StatefulWidget {
  final String email;

  const Verificacion({super.key, required this.email});

  @override
  State<Verificacion> createState() => _VerificacionState();
}

class _VerificacionState extends State<Verificacion> {
  final campos = List.generate(6, (_) => TextEditingController());

  void verificar() {
    final codigo = campos.map((campo) => campo.text).join();

    if (codigo.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(texto('ingresa_codigo'))));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NuevaContrasena(email: widget.email, codigo: codigo),
      ),
    );
  }

  @override
  void dispose() {
    for (final campo in campos) {
      campo.dispose();
    }
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const BarraNavegacion(),
                const SizedBox(height: 25),
                Text(
                  texto('verificar_codigo_recuperacion'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.kronaOne(
                    color: AppColors.goldSand,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 15),
                const Icon(Icons.email, color: AppColors.goldSand, size: 75),
                const SizedBox(height: 40),
                Text(
                  texto('ingresa_codigo'),
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
                    6,
                    (index) => SizedBox(
                      width: 45,
                      height: 50,
                      child: TextField(
                        controller: campos[index],
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
                  texto: texto('verificar_proceder'),
                  onPressed: verificar,
                ),
                const SizedBox(height: 15),
                BotonPrincipal(
                  texto: texto('reenviar_codigo'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
