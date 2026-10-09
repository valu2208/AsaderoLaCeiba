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
import 'package:asadero/pantallas/verificacion.dart';
import 'package:asadero/core/traducciones.dart';

class RecuperarContrasena extends StatelessWidget {
  const RecuperarContrasena({super.key});

  @override
<<<<<<< Updated upstream
=======
  State<RecuperarContrasena> createState() => _RecuperarContrasenaState();
}

class _RecuperarContrasenaState extends State<RecuperarContrasena> {
  final correo = TextEditingController();
  final telefono = TextEditingController();

  Future<void> recuperar() async {
    try {
      final respuesta = await http.post(
        Uri.parse('http://10.0.2.2:3000/recuperar/solicitar'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': correo.text,
        }),
      );

      if (!mounted) return;

      if (respuesta.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Verificacion(
              email: correo.text,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(texto('no_se_pudo_enviar')),
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
    correo.dispose();
    telefono.dispose();
    super.dispose();
  }

  @override
>>>>>>> Stashed changes
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
                texto('recuperar_contrasena'),
                textAlign: TextAlign.center,
                style: GoogleFonts.kronaOne(
                  color: AppColors.goldSand,
                  fontSize: 23,
                ),
              ),
<<<<<<< Updated upstream
              const SizedBox(height: 55),
              const CampoTexto(
                texto: 'Correo Electrónico',
=======
              const SizedBox(height: 90),
              CampoTexto(
                texto: texto('correo_electronico'),
>>>>>>> Stashed changes
                icono: Icons.email,
              ),
<<<<<<< Updated upstream
              const SizedBox(height: 18),
              const CampoTexto(
                texto: 'Teléfono',
=======
              const SizedBox(height: 25),
              CampoTexto(
                texto: texto('telefono'),
>>>>>>> Stashed changes
                icono: Icons.phone,
              ),
              const SizedBox(height: 68),
              BotonPrincipal(
<<<<<<< Updated upstream
                texto: 'Recuperar contraseña',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const Verificacion(),
                    ),
                  );
                },
=======
                texto: texto('recuperar_contrasena'),
                onPressed: recuperar,
>>>>>>> Stashed changes
              ),
            ],
          ),
        ),
      ),
    );
  }
}