import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/services/api_config.dart';
import 'package:asadero/componentes/barra_navegacion.dart';
import 'package:asadero/componentes/boton_principal.dart';
import 'package:asadero/componentes/casillas_codigo.dart';
import 'package:asadero/pantallas/nueva_contrasena.dart';

class Verificacion extends StatefulWidget {
  final String email;

  const Verificacion({super.key, required this.email});

  @override
  State<Verificacion> createState() => _VerificacionState();
}

class _VerificacionState extends State<Verificacion> {
  final codigoController = TextEditingController();

  int segundos = 0;
  bool reenviando = false;
  Timer? temporizador;

  @override
  void dispose() {
    temporizador?.cancel();
    codigoController.dispose();
    super.dispose();
  }

  void aviso(String clave) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(texto(clave))));
  }

  void iniciarEspera() {
    setState(() => segundos = 30);
    temporizador?.cancel();
    temporizador = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (segundos <= 1) {
        t.cancel();
        setState(() => segundos = 0);
      } else {
        setState(() => segundos--);
      }
    });
  }

  Future<void> reenviar() async {
    if (segundos > 0 || reenviando) return;
    setState(() => reenviando = true);

    try {
      final respuesta = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/recuperar/solicitar'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email}),
      );

      if (!mounted) return;

      if (respuesta.statusCode == 200) {
        aviso('codigo_reenviado');
        iniciarEspera();
      } else {
        aviso('no_se_pudo_enviar');
      }
    } catch (e) {
      if (mounted) aviso('error_servidor');
    } finally {
      if (mounted) setState(() => reenviando = false);
    }
  }

  void verificar() {
    final codigo = codigoController.text;

    if (codigo.length != 6) {
      aviso('ingresa_codigo');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NuevaContrasena(email: widget.email, codigo: codigo),
      ),
    );
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const BarraNavegacion(),
                const SizedBox(height: 25),
                Text(
                  texto('verificar_codigo_recuperacion'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.kronaOne(
                    color: AppColors.goldSand,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 15),
                const Icon(Icons.email, color: AppColors.goldSand, size: 75),
                const SizedBox(height: 40),
                Text(
                  texto('ingresa_codigo'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.josefinSans(
                    color: AppColors.goldSand,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 30),
                CasillasCodigo(controller: codigoController, alto: 55),
                const SizedBox(height: 45),
                BotonPrincipal(
                  texto: texto('verificar_proceder'),
                  onPressed: verificar,
                ),
                const SizedBox(height: 15),
                BotonPrincipal(
                  texto: segundos > 0
                      ? '${texto('reenviar_codigo')} (${segundos}s)'
                      : texto('reenviar_codigo'),
                  onPressed: reenviar,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}