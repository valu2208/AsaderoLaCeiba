import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/barra_navegacion.dart';
import 'package:asadero/componentes/campo_texto.dart';
import 'package:asadero/componentes/boton_principal.dart';
import 'package:asadero/pantallas/recuperar_contrasena.dart';
import 'package:asadero/pantallas/registro.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool mostrar = false;
  bool recordar = false;

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
              const SizedBox(height: 20),
              const Icon(Icons.account_circle,
                  color: AppColors.goldSand, size: 80),
              const SizedBox(height: 10),
              Text(
                'Iniciar Sesión',
                style: GoogleFonts.kronaOne(
                  color: AppColors.goldSand,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 60),
              const CampoTexto(texto: 'Nombre', icono: Icons.person),
              const SizedBox(height: 15),
              const CampoTexto(
                  texto: 'Correo Electrónico', icono: Icons.email),
              const SizedBox(height: 15),
              CampoTexto(
                texto: 'Contraseña',
                icono: Icons.lock,
                ocultar: !mostrar,
                onPressed: () => setState(() => mostrar = !mostrar),
              ),
              Row(
                children: [
                  Checkbox(
                    value: recordar,
                    onChanged: (valor) =>
                        setState(() => recordar = valor ?? false),
                  ),
                  const Text('Recordarme',
                      style: TextStyle(color: AppColors.goldSand)),
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
              const SizedBox(height: 30),
              BotonPrincipal(texto: 'Iniciar Sesión', onPressed: () {}),
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
                      child: Divider(color: AppColors.goldSand)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'O Continuar Con',
                      style: TextStyle(color: AppColors.goldSand),
                    ),
                  ),
                  const Expanded(
                      child: Divider(color: AppColors.goldSand)),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.g_mobiledata,
                  color: AppColors.goldSand,
                  size: 45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}