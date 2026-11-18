import 'package:flutter/material.dart';
import 'package:asadero/componentes/dialogo_terminos.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';

class CheckTerminos extends StatelessWidget {
  final bool valor;
  final ValueChanged<bool> onCambio;

  const CheckTerminos({super.key, required this.valor, required this.onCambio});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: valor,
          activeColor: AppColors.goldSand,
          checkColor: AppColors.asphalt,
          side: const BorderSide(color: AppColors.goldSand),
          onChanged: (v) => onCambio(v ?? false),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => mostrarTerminos(context),
            child: Text.rich(TextSpan(
              style: const TextStyle(color: AppColors.goldSand, fontSize: 13),
              children: [
                TextSpan(text: '${texto('terminos_acepto')} '),
                TextSpan(
                  text: texto('terminos_leer'),
                  style: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )),
          ),
        ),
      ],
    );
  }
}