import 'package:flutter/material.dart';
import 'package:asadero/core/limites_pedido.dart';
import 'package:asadero/core/traducciones.dart';

// Muestra el mensaje cuando se llega al límite. "clave" viene de CarritoEstado.agregar.
void avisarLimite(BuildContext context, String? clave) {
  if (clave == null) return;

  final n = clave == 'limite_plato'
      ? LimitesPedido.maxPorPlato
      : LimitesPedido.maxPlatosPedido;

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(texto(clave).replaceAll('{n}', '$n')),
      backgroundColor: Colors.orange,
    ));
}