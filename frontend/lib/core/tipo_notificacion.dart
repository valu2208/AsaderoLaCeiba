import 'package:flutter/material.dart';

// Cómo se ve cada tipo de notificación: color del punto, ícono y nombre
class TipoNotificacion {
  final Color color;
  final IconData icono;
  final String clave; // clave de traducción del nombre

  const TipoNotificacion(this.color, this.icono, this.clave);

  static TipoNotificacion de(String tipo) {
    switch (tipo) {
      case 'bienvenida':
        return const TipoNotificacion(
          Color(0xFF66BB6A),
          Icons.restaurant_outlined,
          'tipo_bienvenida',
        );
      case 'pedido':
        return const TipoNotificacion(
          Color(0xFFFFB300),
          Icons.shopping_bag_outlined,
          'tipo_pedido',
        );
      case 'estado_pedido':
        return const TipoNotificacion(
          Color(0xFF42A5F5),
          Icons.local_dining_outlined,
          'tipo_estado_pedido',
        );
      case 'stock_bajo':
        return const TipoNotificacion(
          Color(0xFFEF5350),
          Icons.inventory_2_outlined,
          'tipo_stock_bajo',
        );
      default:
        return const TipoNotificacion(
          Color(0xFFBDBDBD),
          Icons.notifications_outlined,
          'tipo_aviso',
        );
    }
  }
}