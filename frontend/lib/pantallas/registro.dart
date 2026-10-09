<<<<<<< Updated upstream
=======
import 'dart:convert';
>>>>>>> Stashed changes
import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/barra_navegacion.dart';
import 'package:asadero/componentes/campo_texto.dart';
import 'package:asadero/componentes/boton_principal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/pantallas/verificar_correo.dart';
import 'package:asadero/core/traducciones.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  bool mostrarContrasena = false;
  bool mostrarConfirmar = false;

<<<<<<< Updated upstream
=======
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(texto('error_contrasenas'))),
      );
      return;
    }

    try {
      print('CORREO ENVIADO: ${correo.text}');
      final respuesta = await http.post(
        Uri.parse('http://10.0.2.2:3000/usuarios'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombre.text,
          'telefono': telefono.text,
          'email': correo.text,
          'password': clave.text,
        }),
      );

      print('STATUS: ${respuesta.statusCode}');
      print('RESPUESTA: ${respuesta.body}');

      if (!mounted) return;

      if (respuesta.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerificarCorreo(email: correo.text),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(texto('correo_registrado'))),
        );
      }
    } catch (e) {
      print('ERROR: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(texto('error_servidor'))),
      );
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

      print(respuesta.body);
    } catch (e) {
      print(e);
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

>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
              const SizedBox(height: 30),
              Text(
                'Regístrate',
=======
              const SizedBox(height: 26),
              Text( texto (
                'Regístrate'),
>>>>>>> Stashed changes
                style: GoogleFonts.kronaOne(
                  color: AppColors.goldSand,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
<<<<<<< Updated upstream
              const SizedBox(height: 55),
              const CampoTexto(texto: 'Nombre', icono: Icons.person),
              const SizedBox(height: 20),
              const CampoTexto(texto: 'Teléfono', icono: Icons.phone),
              const SizedBox(height: 20),
              const CampoTexto(texto: 'Correo Electrónico', icono: Icons.email),
=======
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
              ),
              const SizedBox(height: 20),
              CampoTexto(
                texto: texto('correo_electronico'),
                icono: Icons.email,
                controller: correo,
              ),
>>>>>>> Stashed changes
              const SizedBox(height: 20),
              CampoTexto(
                texto: texto('contrasena'),
                icono: Icons.lock,
                ocultar: !mostrarContrasena,
                onPressed: () =>
                    setState(() => mostrarContrasena = !mostrarContrasena),
              ),
              const SizedBox(height: 20),
              CampoTexto(
                texto: texto('confirmar_contrasena'),

                icono: Icons.lock_outline,
                ocultar: !mostrarConfirmar,
                onPressed: () =>
                    setState(() => mostrarConfirmar = !mostrarConfirmar),
              ),
              const SizedBox(height: 35),
<<<<<<< Updated upstream
              BotonPrincipal(
                texto: 'Crear Cuenta',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VerificarCorreo()),
                  );
                },
              ),
=======
              BotonPrincipal(texto: texto('crear_cuenta_boton'), onPressed: registrar),
>>>>>>> Stashed changes
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.goldSand)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      texto('continuar_con'),
                      style: TextStyle(color: AppColors.goldSand),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.goldSand)),
                ],
              ),
              IconButton(
                onPressed: () {},
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
