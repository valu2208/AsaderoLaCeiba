import 'package:flutter/material.dart';

// Color del punto de estado de un pedido:
// rojo = por preparar, naranja = preparando, verde = listo.
Color colorEstado(String estado) {
  switch (estado) {
    case 'Pendiente':
    case 'En cocina':
      return const Color(0xFFE53935);
    case 'En preparación':
      return Colors.orange;
    case 'Listo':
      return Colors.green;
    default:
      return Colors.grey;
  }
}