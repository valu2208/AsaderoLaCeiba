import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/core/traducciones.dart';

class DetallePedido extends StatelessWidget {
  final Map<String, String> pedido;
  final String producto;
  final String estado;

  const DetallePedido({
    super.key,
    required this.pedido,
    required this.producto,
    required this.estado,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Idioma.seleccionado,
      builder: (context, idioma, child) {
        return AlertDialog(
          backgroundColor: AppColors.asphalt,
          title: Text(
            pedido['numero']!,
            style: const TextStyle(color: AppColors.goldSand),
          ),
          content: Text(
            '${texto('fecha')}: ${pedido['fecha']}\n\n'
            '${texto('productos')}: $producto\n\n'
            '${texto('total')}: ${pedido['total']}\n\n'
            '${texto('estado')}: $estado',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                texto('cerrar'),
                style: const TextStyle(
                  color: AppColors.goldSand,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
