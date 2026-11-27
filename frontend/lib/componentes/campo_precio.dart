import 'package:flutter/material.dart';
import 'package:asadero/core/estilo_campo.dart';
import 'package:asadero/core/formato_miles.dart';

// Campo del precio en pesos: pone los puntos de miles solo (25000 -> 25.000)
class CampoPrecio extends StatelessWidget {
  final TextEditingController controller;

  const CampoPrecio({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FormatoMiles()],
      decoration: decoracionCampo('Precio (\$)'),
      validator: (valor) {
        final numero = int.tryParse(soloDigitos(valor ?? ''));
        return numero == null || numero <= 0 ? 'Ingresa un precio válido' : null;
      },
    );
  }
}