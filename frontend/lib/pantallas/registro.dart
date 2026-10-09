import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/componentes/barra_navegacion.dart';
import 'package:asadero/componentes/campo_texto.dart';
import 'package:asadero/componentes/boton_principal.dart';
import 'package:asadero/pantallas/verificar_correo.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final nombre = TextEditingController();
  final telefono = TextEditingController();
  final correo = TextEditingController();
  final clave = TextEditingController();
  final confirmar = TextEditingController();

  bool mostrar = false;
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

  Future<void> registrar() async {
    if (clave.text != confirmar.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(texto('error_contrasenas'))));
      return;
    }

    try {
      final respuesta = await http.post(
        Uri.parse('http://10.0.2.2:3000/usuarios'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombre.text.trim(),
          'telefono': telefono.text.trim(),
          'email': correo.text.trim(),
          'password': clave.text,
        }),
      );

      if (!mounted) return;

      if (respuesta.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerificarCorreo(email: correo.text.trim()),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(texto('correo_registrado'))));
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(texto('error_servidor'))));
    }
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

      debugPrint(respuesta.body);
    } catch (e) {
      debugPrint('Error al registrarse con Google: $e');
    }
  }

  @override
  void dispose() {
    nombre.dispose();
    telefono.dispose();
    correo.dispose();
    clave.dispose();
    confirmar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.asphalt,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const BarraNavegacion(),
              const SizedBox(height: 2),
              const Icon(
                Icons.account_circle,
                color: AppColors.goldSand,
                size: 100,
              ),
              const SizedBox(height: 26),
              Text(
                texto('registrarse'),
                style: GoogleFonts.kronaOne(
                  color: AppColors.goldSand,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 51),
              CampoTexto(
                texto: texto('nombre'),
                icono: Icons.person,
                controller: nombre,
              ),
              const SizedBox(height: 20),
              CampoTexto(
                texto: texto('telefono'),
                icono: Icons.phone,
                controller: telefono,
                teclado: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              CampoTexto(
                texto: texto('correo_electronico'),
                icono: Icons.email,
                controller: correo,
                teclado: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              CampoTexto(
                texto: texto('contrasena'),
                icono: Icons.lock,
                ocultar: !mostrar,
                controller: clave,
                onPressed: () {
                  setState(() => mostrar = !mostrar);
                },
              ),
              const SizedBox(height: 20),
              CampoTexto(
                texto: texto('confirmar_contrasena'),
                icono: Icons.lock_outline,
                ocultar: !mostrarConfirmar,
                controller: confirmar,
                onPressed: () {
                  setState(() {
                    mostrarConfirmar = !mostrarConfirmar;
                  });
                },
              ),
              const SizedBox(height: 35),
              BotonPrincipal(
                texto: texto('crear_cuenta_boton'),
                onPressed: registrar,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.goldSand)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      texto('continuar_con'),
                      style: const TextStyle(color: AppColors.goldSand),
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
