import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/barra_navegacion.dart';
import 'package:asadero/componentes/campo_texto.dart';
import 'package:asadero/componentes/boton_principal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/pantallas/verificar_correo.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  bool mostrarContrasena = false;
  bool mostrarConfirmar = false;

  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  late Future<void> googleInicializado;

  @override
  void initState() {
    super.initState();

    googleInicializado = googleSignIn.initialize(
      serverClientId:
          '1048054296808-qmul3sdksffmij6scb9rs71o16rjnm84.apps.googleusercontent.com',
    );
  }

  Future<void> registrarConGoogle() async {
    try {
      await googleInicializado;

      final usuario = await googleSignIn.authenticate();
      final idToken = usuario.authentication.idToken;

      if (idToken == null) return;

      final respuesta = await http.post(
        Uri.parse('http://10.0.2.2:3000/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      print(respuesta.body);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.asphalt,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const BarraNavegacion(),
              const SizedBox(height: 5),
              const Icon(
                Icons.account_circle,
                color: AppColors.goldSand,
                size: 90,
              ),
              const SizedBox(height: 30),
              Text(
                'Regístrate',
                style: GoogleFonts.kronaOne(
                  color: AppColors.goldSand,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 55),
              const CampoTexto(texto: 'Nombre', icono: Icons.person),
              const SizedBox(height: 20),
              const CampoTexto(texto: 'Teléfono', icono: Icons.phone),
              const SizedBox(height: 20),
              const CampoTexto(texto: 'Correo Electrónico', icono: Icons.email),
              const SizedBox(height: 20),
              CampoTexto(
                texto: 'Contraseña',
                icono: Icons.lock,
                ocultar: !mostrarContrasena,
                onPressed: () =>
                    setState(() => mostrarContrasena = !mostrarContrasena),
              ),
              const SizedBox(height: 20),
              CampoTexto(
                texto: 'Confirmar contraseña',
                icono: Icons.lock_outline,
                ocultar: !mostrarConfirmar,
                onPressed: () =>
                    setState(() => mostrarConfirmar = !mostrarConfirmar),
              ),
              const SizedBox(height: 35),
              BotonPrincipal(
                texto: 'Crear Cuenta',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VerificarCorreo()),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.goldSand)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'O Continuar Con',
                      style: TextStyle(color: AppColors.goldSand),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.goldSand)),
                ],
              ),
              IconButton(
                onPressed: registrarConGoogle,
                icon: const Icon(
                  Icons.g_mobiledata,
                  color: AppColors.goldSand,
                  size: 41,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
