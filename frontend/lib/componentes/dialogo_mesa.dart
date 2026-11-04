import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:asadero/core/colores.dart';
import '../models/pedido_personal.dart';

// Pide el número de mesa al enviar un pedido a cocina. Devuelve null si se cancela.
Future<int?> pedirMesa(BuildContext context, PedidoPersonal pedido) {
  final controlador = TextEditingController(text: pedido.mesa?.toString() ?? '');

  return showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.asphalt,
      title: Text(
        'Pedido #${pedido.id}',
        style: const TextStyle(color: AppColors.goldSand),
      ),
      content: TextField(
        controller: controlador,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(color: AppColors.goldSand),
        decoration: const InputDecoration(
          labelText: '¿En qué mesa está el cliente?',
          labelStyle: TextStyle(color: AppColors.goldSand),
          enabledBorder: UnderlineInputBorder(
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
            final mesa = int.tryParse(controlador.text.trim());
            if (mesa != null && mesa > 0) Navigator.pop(context, mesa);
          },
          child: const Text('Enviar', style: TextStyle(color: AppColors.redPrayerFlag)),
        ),
      ],
    ),
  );
}