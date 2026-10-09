<<<<<<< Updated upstream
=======
import 'dart:convert';
>>>>>>> Stashed changes
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/barra_navegacion.dart';
import 'package:asadero/componentes/campo_texto.dart';
import 'package:asadero/componentes/boton_principal.dart';
import 'package:asadero/pantallas/login.dart';
import 'package:asadero/core/traducciones.dart';
class NuevaContrasena extends StatefulWidget {
<<<<<<< Updated upstream
  const NuevaContrasena({super.key});
=======
  final String email;

  final String codigo;

  const NuevaContrasena({
    super.key,
    required this.email,
    required this.codigo,
  });
>>>>>>> Stashed changes

  @override
  State<NuevaContrasena> createState() => _NuevaContrasenaState();
}

class _NuevaContrasenaState extends State<NuevaContrasena> {
  bool mostrar = false;

<<<<<<< Updated upstream
=======
  final clave = TextEditingController();

  final confirmar = TextEditingController();

  Future<void> cambiar() async {
    if (clave.text != confirmar.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(texto('error_contrasenas')),
        ),
      );

      return;
    }

    try {
      final respuesta = await http.post(
        Uri.parse('http://10.0.2.2:3000/recuperar/restablecer'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'codigo': widget.codigo,
          'nuevaPassword': clave.text,
        }),
      );

      print('STATUS: ${respuesta.statusCode}');
      print('RESPUESTA: ${respuesta.body}');

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
            content: Text(respuesta.body),
          ),
        );
      }
    } catch (e) {
      print('ERROR: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(texto('error_servidor')),
        ),
      );
    }
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
                Text(
                  texto('restaurar_contrasena'),
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
                  texto('escribir_nueva_contrasena'),
                  style: GoogleFonts.kronaOne(
                    color: AppColors.goldSand,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 50),
                CampoTexto(
                  texto: texto('nueva_contrasena'),
                  icono: Icons.lock,
                  ocultar: !mostrar,
                  estiloNuevo: true,
                  onPressed: () => setState(() => mostrar = !mostrar),
                ),
                const SizedBox(height: 18),
                CampoTexto(
                  texto: texto('confirmar_nueva_contrasena'),
                  icono: Icons.lock,
                  ocultar: !mostrar,
                  estiloNuevo: true,
                  onPressed: () => setState(() => mostrar = !mostrar),
                ),
                const SizedBox(height: 75),
                BotonPrincipal(
<<<<<<< Updated upstream
                  texto: 'Continuar',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Login(),
                      ),
                    );
                  },
=======
                  texto: texto('continuar'),
                  onPressed: cambiar,
>>>>>>> Stashed changes
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}