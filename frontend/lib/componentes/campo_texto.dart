import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

class CampoTexto extends StatelessWidget {
  final String texto;
  final IconData icono;
  final bool ocultar;
  final VoidCallback? onPressed;
  final TextInputType? teclado;
  final int? maxLength;
  final TextAlign alineacion;
  final bool estiloNuevo;

  const CampoTexto({
    super.key,
    required this.texto,
    required this.icono,
    this.ocultar = false,
    this.onPressed,
    this.teclado,
    this.maxLength,
    this.alineacion = TextAlign.start,
    this.estiloNuevo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: estiloNuevo
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF3B0000),
                  Color(0xFF7A0C00),
                  Color(0xFF8C0B00),
                ],
              )
            : null,
        color: estiloNuevo ? null : AppColors.earthBrown,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        obscureText: ocultar,
        keyboardType: teclado,
        maxLength: maxLength,
        textAlign: alineacion,
        style: TextStyle(
          color: estiloNuevo
              ? const Color(0xFFFFE093)
              : AppColors.goldSand,
        ),
        decoration: InputDecoration(
          labelText: texto,
          labelStyle: TextStyle(
            color: estiloNuevo
                ? const Color(0xFFFFE093)
                : AppColors.goldSand,
          ),
          filled: true,
          fillColor: Colors.transparent,
          prefixIcon: Icon(
            icono,
            color: estiloNuevo
                ? const Color(0xFFFFE093)
                : AppColors.redPrayerFlag,
          ),
          counterText: maxLength == null ? null : '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          suffixIcon: onPressed == null
              ? null
              : IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    ocultar ? Icons.visibility_off : Icons.visibility,
                    color: estiloNuevo
                        ? const Color(0xFFFFE093)
                        : AppColors.redPrayerFlag,
                  ),
                ),
        ),
      ),
    );
  }
}