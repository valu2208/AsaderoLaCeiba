import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/componentes/barra_navegacion.dart';
import 'package:asadero/componentes/boton_principal.dart';
import 'package:asadero/pantallas/login.dart';
import 'package:asadero/services/user_service.dart';
import 'package:asadero/core/navegacion_rol.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  Future<void> _comenzar(BuildContext context) async {
    try {
      // Comprobar si existe una sesión válida.
      final token = await UserService.getToken();

      if (!context.mounted) return;

      if (token != null && token.isNotEmpty) {
        // Recuperar el rol del usuario guardado.
        final rol = await UserService.getRol();

        if (!context.mounted) return;

        // Entrar directamente a su pantalla correspondiente.
        irSegunRol(context, rol);
      } else {
        // Si no hay sesión, abrir el login.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Login()),
        );
      }
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo comprobar la sesión. Intenta nuevamente.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.asphalt,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const BarraNavegacion(),
              const Spacer(flex: 1),
              Text(
                texto('tu_proxima_gran_idea'),
                textAlign: TextAlign.center,
                style: GoogleFonts.kronaOne(
                  color: AppColors.goldSand,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 110),
              Text(
                texto('mensaje_inicio'),
                textAlign: TextAlign.center,
                style: GoogleFonts.kronaOne(
                  color: AppColors.goldSand,
                  fontSize: 18,
                ),
              ),
              const Spacer(flex: 3),
              BotonPrincipal(
                texto: texto('comenzar'),
                onPressed: () => _comenzar(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
