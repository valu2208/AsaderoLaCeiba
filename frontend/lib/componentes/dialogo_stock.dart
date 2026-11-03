import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:asadero/core/colores.dart';
import '../models/ingrediente.dart';

// Pide la nueva cantidad de un ingrediente. Devuelve null si se cancela.
Future<int?> pedirStock(BuildContext context, Ingrediente ingrediente) {
  final controlador = TextEditingController(text: '${ingrediente.stockActual}');

  return showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.asphalt,
      title: Text(
        ingrediente.nombre,
        style: const TextStyle(color: AppColors.goldSand),
      ),
      content: TextField(
        controller: controlador,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(color: AppColors.goldSand),
        decoration: InputDecoration(
          labelText: 'Cantidad disponible (${ingrediente.unidad})',
          labelStyle: const TextStyle(color: AppColors.goldSand),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.goldSand),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: AppColors.goldSand)),
        ),
        TextButton(
          onPressed: () {
            final valor = int.tryParse(controlador.text.trim());
            if (valor != null) Navigator.pop(context, valor);
          },
          child: const Text('Guardar', style: TextStyle(color: AppColors.redPrayerFlag)),
        ),
      ],
    ),
  );
}