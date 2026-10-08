import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/barra_navegacion.dart';
import 'package:asadero/componentes/campo_texto.dart';
import 'package:asadero/componentes/boton_principal.dart';
import 'package:asadero/pantallas/verificacion.dart';

class RecuperarContrasena extends StatefulWidget {
  const RecuperarContrasena({super.key});

  @override
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
          const SnackBar(
            content: Text('No se pudo enviar el código'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo conectar con el servidor'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.asphalt,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const BarraNavegacion(),
              const SizedBox(height: 10),
              const Icon(
                Icons.key,
                color: AppColors.goldSand,
                size: 110,
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
              const SizedBox(height: 90),
              CampoTexto(
                texto: 'Correo Electrónico',
                icono: Icons.email,
                controller: correo,
              ),
              const SizedBox(height: 25),
              CampoTexto(
                texto: 'Teléfono',
                icono: Icons.phone,
                controller: telefono,
              ),
              const SizedBox(height: 145),
              BotonPrincipal(
                texto: 'Recuperar contraseña',
                onPressed: recuperar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}