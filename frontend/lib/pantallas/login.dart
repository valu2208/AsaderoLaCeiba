import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import 'package:google_sign_in/google_sign_in.dart';

import 'package:asadero/core/colores.dart';

import 'package:asadero/componentes/barra_navegacion.dart';

import 'package:asadero/componentes/campo_texto.dart';

import 'package:asadero/componentes/boton_principal.dart';

import 'package:asadero/pantallas/recuperar_contrasena.dart';

import 'package:asadero/pantallas/registro.dart';

import 'package:asadero/pantallas/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  bool mostrar = false;
  bool recordar = false;

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

  Future<void> iniciarSesionGoogle() async {
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

      if (respuesta.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Home()),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> iniciarSesion() async {
    try {
      final respuesta = await http.post(
        Uri.parse('http://10.0.2.2:3000/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': correoController.text,
          'password': contrasenaController.text,
        }),
      );

      if (respuesta.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Home()),
        );
      } else {
        print(respuesta.body);
      }
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

              const SizedBox(height: 20),

              const Icon(
                Icons.account_circle,
                color: AppColors.goldSand,
                size: 100,
              ),

              const SizedBox(height: 5),

              Text(
                'Iniciar Sesión',
                style: GoogleFonts.kronaOne(
                  color: AppColors.goldSand,
                  fontSize: 30,
                ),
              ),

              const SizedBox(height: 58),

              const CampoTexto(
                texto: 'Nombre',
                icono: Icons.person,
              ),

              const SizedBox(height: 20),

              CampoTexto(
                texto: 'Correo Electrónico',
                icono: Icons.email,
                controller: correoController,
              ),

              const SizedBox(height: 20),

              CampoTexto(
                texto: 'Contraseña',
                icono: Icons.lock,
                ocultar: !mostrar,
                onPressed: () => setState(() => mostrar = !mostrar),
                controller: contrasenaController,
              ),

              Row(
                children: [
                  Checkbox(
                    value: recordar,
                    onChanged: (valor) =>
                        setState(() => recordar = valor ?? false),
                  ),

                  const Text(
                    'Recordarme',
                    style: TextStyle(color: AppColors.goldSand),
                  ),

                  const Spacer(),

                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RecuperarContrasena(),
                      ),
                    ),
                    child: const Text(
                      '¿Olvidaste Contraseña?',
                      style: TextStyle(color: AppColors.goldSand),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              BotonPrincipal(
                texto: 'Iniciar Sesión',
                onPressed: iniciarSesion,
              ),

              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Registro()),
                ),
                child: const Text(
                  '¿No tienes cuenta? Regístrate',
                  style: TextStyle(
                    color: AppColors.goldSand,
                    fontSize: 16,
                  ),
                ),
              ),

              Row(
                children: [
                  const Expanded(
                    child: Divider(color: AppColors.goldSand),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'O Continuar Con',
                      style: TextStyle(color: AppColors.goldSand),
                    ),
                  ),

                  const Expanded(
                    child: Divider(color: AppColors.goldSand),
                  ),
                ],
              ),

              IconButton(
                onPressed: iniciarSesionGoogle,
                icon: const Icon(
                  Icons.g_mobiledata,
                  color: AppColors.goldSand,
                  size: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}