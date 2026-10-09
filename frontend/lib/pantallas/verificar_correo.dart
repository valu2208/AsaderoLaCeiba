<<<<<<< Updated upstream
=======
import 'dart:convert';
>>>>>>> Stashed changes
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/barra_navegacion.dart';
import 'package:asadero/componentes/boton_principal.dart';
import 'package:asadero/pantallas/login.dart';
import 'package:asadero/core/traducciones.dart';

<<<<<<< Updated upstream
class VerificarCorreo extends StatelessWidget {
  const VerificarCorreo({super.key});
=======
class VerificarCorreo extends StatefulWidget {
  final String email;

  const VerificarCorreo({
    super.key,
    required this.email,
  });

  @override
  State<VerificarCorreo> createState() => _VerificarCorreoState();
}

class _VerificarCorreoState extends State<VerificarCorreo> {
  final List<TextEditingController> campos = List.generate(
    6,
    (_) => TextEditingController(),
  );

  Future<void> verificar() async {
    final codigo = campos.map((campo) => campo.text).join();

    try {
      final respuesta = await http.post(
        Uri.parse('http://10.0.2.2:3000/usuarios/verificar'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'codigo': codigo,
        }),
      );

      if (!mounted) return;

      if (respuesta.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const Login(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(texto('codigo_incorrecto')),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(texto('error_servidor')),
        ),
      );
    }
  }

  @override
  void dispose() {
    for (final campo in campos) {
      campo.dispose();
    }
    super.dispose();
  }
>>>>>>> Stashed changes

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
                Text( texto(
                  'verificando_correo'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.kronaOne(
                    color: AppColors.goldSand,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 15),
                const Icon(Icons.email, color: AppColors.goldSand, size: 65),
                const SizedBox(height: 20),
                Text( texto(
                  'ingresa_codigo'),
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
<<<<<<< Updated upstream
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
=======
                  texto: texto('verificar_proceder'),
                  onPressed: verificar,
                ),
                const SizedBox(height: 20),
                BotonPrincipal(
                  texto: texto('reenviar_codigo'),
                  onPressed: () {},
                ),
>>>>>>> Stashed changes
              ],
            ),
          ),
        ),
      ),
    );
  }
}
