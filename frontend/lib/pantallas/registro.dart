import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/barra_navegacion.dart';
import 'package:asadero/componentes/campo_texto.dart';
import 'package:asadero/componentes/boton_principal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/pantallas/verificar_correo.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  bool mostrarContrasena = false;
  bool mostrarConfirmar = false;

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
