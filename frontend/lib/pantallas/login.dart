import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
<<<<<<< Updated upstream
import 'package:asadero/core/colores.dart';
=======
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';
>>>>>>> Stashed changes
import 'package:asadero/componentes/barra_navegacion.dart';
import 'package:asadero/componentes/campo_texto.dart';
import 'package:asadero/componentes/boton_principal.dart';
import 'package:asadero/pantallas/recuperar_contrasena.dart';
import 'package:asadero/pantallas/registro.dart';
<<<<<<< Updated upstream
=======
import 'package:asadero/pantallas/home.dart';
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
              const Icon(Icons.account_circle,
                  color: AppColors.goldSand, size: 80),
              const SizedBox(height: 10),
=======
              const Icon(
                Icons.account_circle,
                color: AppColors.goldSand,
                size: 100,
              ),
              const SizedBox(height: 5),
>>>>>>> Stashed changes
              Text(
                texto('iniciar_sesion_titulo'),
                style: GoogleFonts.kronaOne(
                  color: AppColors.goldSand,
                  fontSize: 30,
                ),
              ),
<<<<<<< Updated upstream
              const SizedBox(height: 60),
              const CampoTexto(texto: 'Nombre', icono: Icons.person),
              const SizedBox(height: 15),
              const CampoTexto(
                  texto: 'Correo Electrónico', icono: Icons.email),
              const SizedBox(height: 15),
=======
              const SizedBox(height: 58),

              CampoTexto(
                texto: texto('nombre'),
                icono: Icons.person,
              ),

              const SizedBox(height: 20),

              CampoTexto(
                texto: texto('correo_electronico'),
                icono: Icons.email,
                controller: correoController,
              ),

              const SizedBox(height: 20),

>>>>>>> Stashed changes
              CampoTexto(
                texto: texto('contrasena'),
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
<<<<<<< Updated upstream
                  const Text('Recordarme',
                      style: TextStyle(color: AppColors.goldSand)),
=======

                  Text(
                    texto('recordarme'),
                    style: const TextStyle(
                      color: AppColors.goldSand,
                    ),
                  ),

>>>>>>> Stashed changes
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RecuperarContrasena(),
                      ),
                    ),
                    child: Text(
                      texto('olvidaste_contrasena'),
                      style: const TextStyle(
                        color: AppColors.goldSand,
                      ),
                    ),
                  ),
                ],
              ),
<<<<<<< Updated upstream
              const SizedBox(height: 30),
              BotonPrincipal(texto: 'Iniciar Sesión', onPressed: () {}),
=======

              const SizedBox(height: 28),

              BotonPrincipal(
                texto: texto('iniciar_sesion_titulo'),
                onPressed: iniciarSesion,
              ),

>>>>>>> Stashed changes
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Registro(),
                  ),
                ),
                child: Text(
                  texto('no_tienes_cuenta'),
                  style: const TextStyle(
                    color: AppColors.goldSand,
                    fontSize: 16,
                  ),
                ),
              ),
              Row(
                children: [
                  const Expanded(
<<<<<<< Updated upstream
                      child: Divider(color: AppColors.goldSand)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
=======
                    child: Divider(
                      color: AppColors.goldSand,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
>>>>>>> Stashed changes
                    child: Text(
                      texto('continuar_con'),
                      style: const TextStyle(
                        color: AppColors.goldSand,
                      ),
                    ),
                  ),
                  const Expanded(
<<<<<<< Updated upstream
                      child: Divider(color: AppColors.goldSand)),
=======
                    child: Divider(
                      color: AppColors.goldSand,
                    ),
                  ),
>>>>>>> Stashed changes
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