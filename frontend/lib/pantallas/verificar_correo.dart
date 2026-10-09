import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/componentes/barra_navegacion.dart';
import 'package:asadero/componentes/boton_principal.dart';
import 'package:asadero/pantallas/login.dart';

class VerificarCorreo extends StatefulWidget {
  final String email;

  const VerificarCorreo({super.key, required this.email});

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

    if (codigo.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(texto('ingresa_codigo'))));
      return;
    }

    try {
      final respuesta = await http.post(
        Uri.parse('http://10.0.2.2:3000/usuarios/verificar'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email, 'codigo': codigo}),
      );

      if (!mounted) return;

      if (respuesta.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Login()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(texto('codigo_incorrecto'))));
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(texto('error_servidor'))));
    }
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
                  texto('verificando_correo'),
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
                  texto('ingresa_codigo'),
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
                const SizedBox(height: 60),
                BotonPrincipal(
                  texto: texto('verificar_proceder'),
                  onPressed: verificar,
                ),
                const SizedBox(height: 20),
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
