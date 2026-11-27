import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/formato_miles.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/componentes/imagen_adaptable.dart';

// Platos (foto, cantidad, precio), mesa, estado y total de un pedido,
// para la ventana de detalle de una notificación
class ResumenPedidoNotificacion extends StatelessWidget {
  final Map<String, dynamic> pedido;

  const ResumenPedidoNotificacion({super.key, required this.pedido});

  Widget _fila(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        '$etiqueta: $valor',
        style: const TextStyle(color: AppColors.goldSand, fontSize: 13),
      ),
    );
  }

  Widget _plato(Map<String, dynamic> item) {
    final imagen = '${item['imagen_url'] ?? ''}';
    final precio = num.tryParse('${item['precio']}') ?? 0;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 52,
              height: 52,
              child: imagen.isEmpty
                  ? const Icon(Icons.restaurant, color: AppColors.goldSand)
                  : ImagenAdaptable(ruta: imagen),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${item['cantidad']} x ${item['nombre']}',
              style: const TextStyle(color: AppColors.goldSand),
            ),
          ),
          Text(
            '\$${formatoMiles(precio)}',
            style: const TextStyle(color: AppColors.goldSand, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = List<Map<String, dynamic>>.from(
      (pedido['items'] as List? ?? []).map((i) => Map<String, dynamic>.from(i)),
    );
    final total = num.tryParse('${pedido['total']}') ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: AppColors.goldSand, height: 24),
        for (final item in items) _plato(item),
        const SizedBox(height: 10),
        if (pedido['mesa'] != null) _fila(texto('mesa'), '${pedido['mesa']}'),
        _fila(texto('estado'), '${pedido['estado']}'),
        _fila(texto('total'), '\$${formatoMiles(total)}'),
      ],
    );
  }
}