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
import 'package:asadero/componentes/check_terminos.dart';
import 'package:asadero/pantallas/verificar_correo.dart';
import 'package:asadero/services/api_config.dart';

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
  bool aceptaTerminos = false;

  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  late Future<void> googleInicializado;

  @override
  void initState() {
    super.initState();
    googleInicializado = googleSignIn.initialize(
      serverClientId:
          '978670292562-6f3qglp23eod82ig7vcj1h3i52p3p0gm.apps.googleusercontent.com',
    );
  }

  Future<void> registrar() async {
    if (!aceptaTerminos) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(texto('terminos_requeridos'))));
      return;
    }

    if (clave.text != confirmar.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(texto('error_contrasenas'))));
      return;
    }

    try {
      final respuesta = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/usuarios'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombre.text.trim(),
          'telefono': telefono.text.trim(),
          'email': correo.text.trim(),
          'password': clave.text,
          'acepto_terminos': true,
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
    if (!aceptaTerminos) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(texto('terminos_requeridos'))));
      return;
    }

    try {
      await googleInicializado;

      final usuario = await googleSignIn.authenticate();
      final idToken = usuario.authentication.idToken;

      if (idToken == null) return;

      final respuesta = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken, 'acepto_terminos': true}),
      );

      debugPrint(respuesta.body);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(texto('error_registro_google'))));

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
                texto('registro'),
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
                texto: texto('mensaje_contrasena'),
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
              const SizedBox(height: 20),
              CheckTerminos(
                valor: aceptaTerminos,
                onCambio: (v) => setState(() => aceptaTerminos = v),
              ),
              const SizedBox(height: 15),
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
              TextButton.icon(
                onPressed: registrarConGoogle,
                icon: const Icon(
                  Icons.g_mobiledata,
                  color: AppColors.goldSand,
                  size: 35,
                ),
                label: const Text(
                  'Google',
                  style: TextStyle(
                    color: AppColors.goldSand,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
