import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/barra_navegacion.dart';
import 'package:asadero/componentes/campo_texto.dart';
import 'package:asadero/componentes/boton_principal.dart';
import 'package:asadero/pantallas/login.dart';

class NuevaContrasena extends StatefulWidget {
  final String email;
  final String codigo;

  const NuevaContrasena({
    super.key,
    required this.email,
    required this.codigo,
  });

  @override
  State<NuevaContrasena> createState() => _NuevaContrasenaState();
}

class _NuevaContrasenaState extends State<NuevaContrasena> {
  bool mostrar = false;

  final clave = TextEditingController();
  final confirmar = TextEditingController();

  Future<void> cambiar() async {
  if (clave.text != confirmar.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Las contraseñas no coinciden'),
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
      const SnackBar(
        content: Text('No se pudo conectar con el servidor'),
      ),
    );
  }
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
                  controller: clave,
                  onPressed: () {
                    setState(() {
                      mostrar = !mostrar;
                    });
                  },
                ),
                const SizedBox(height: 18),
                CampoTexto(
                  texto: 'Confirmar nueva contraseña',
                  icono: Icons.lock,
                  ocultar: !mostrar,
                  estiloNuevo: true,
                  controller: confirmar,
                  onPressed: () {
                    setState(() {
                      mostrar = !mostrar;
                    });
                  },
                ),
                const SizedBox(height: 75),
                BotonPrincipal(
                  texto: 'Continuar',
                  onPressed: cambiar,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}