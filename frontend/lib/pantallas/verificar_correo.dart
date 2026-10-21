import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/componentes/barra_navegacion.dart';
import 'package:asadero/componentes/boton_principal.dart';
import 'package:asadero/pantallas/login.dart';

class VerificarCorreo extends StatefulWidget {
  final String email;

  const VerificarCorreo({super.key, required this.email});

  @override
  State<VerificarCorreo> createState() => _VerificarCorreoState();
}

class _VerificarCorreoState extends State<VerificarCorreo> {
  final codigoController = TextEditingController();
  final codigoFoco = FocusNode();

  @override
  void initState() {
    super.initState();
    codigoController.addListener(() => setState(() {}));
    codigoFoco.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    codigoController.dispose();
    codigoFoco.dispose();
    super.dispose();
  }

  void aviso(String clave) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(texto(clave))));
  }

  void enfocarCampo() {
    codigoFoco.requestFocus();
    codigoController.selection = TextSelection.collapsed(
      offset: codigoController.text.length,
    );
  }

  Future<void> verificar() async {
    final codigo = codigoController.text;

    if (codigo.length != 6) {
      aviso('ingresa_codigo');
      return;
    }

    try {
      final respuesta = await http.post(
        Uri.parse('http://10.0.2.2:3000/usuarios/verificar'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email, 'codigo': codigo}),
      );

      if (!mounted) return;

      if (respuesta.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Login()),
        );
      } else {
        aviso('codigo_incorrecto');
      }
    } catch (e) {
      if (mounted) aviso('error_servidor');
    }
  }

  Widget casilla(int index, List<String> digitos) {
    final estaActiva =
        codigoFoco.hasFocus && index == digitos.length.clamp(0, 5);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enfocarCampo,
      child: Container(
        width: 45,
        height: 65,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.goldSand,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: estaActiva ? AppColors.redPrayerFlag : AppColors.earthBrown,
            width: estaActiva ? 2 : 1,
          ),
        ),
        child: Text(
          index < digitos.length ? digitos[index] : '',
          style: const TextStyle(
            color: AppColors.asphalt,
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final digitos = codigoController.text.split('');

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
                  texto('verificando_correo'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.kronaOne(
                    color: AppColors.goldSand,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 15),
                const Icon(Icons.email, color: AppColors.goldSand, size: 65),
                const SizedBox(height: 20),
                Text(
                  texto('ingresa_codigo'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.josefinSans(
                    color: AppColors.goldSand,
                    fontSize: 23,
                  ),
                ),
                const SizedBox(height: 45),

                // Un solo campo de texto con seis casillas visuales
                SizedBox(
                  height: 65,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: TextField(
                          controller: codigoController,
                          focusNode: codigoFoco,
                          autofocus: true,
                          enableInteractiveSelection: false,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          textAlign: TextAlign.center,
                          maxLength: 6,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          style: const TextStyle(
                            color: Colors.transparent,
                            fontSize: 1,
                          ),
                          cursorColor: Colors.transparent,
                          showCursor: false,
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isCollapsed: true,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (i) => casilla(i, digitos)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),
                BotonPrincipal(
                  texto: texto('verificar_proceder'),
                  onPressed: verificar,
                ),
                const SizedBox(height: 20),
                BotonPrincipal(
                  texto: texto('reenviar_codigo'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
