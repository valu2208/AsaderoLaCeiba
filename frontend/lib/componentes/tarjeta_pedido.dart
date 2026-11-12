import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';

class TarjetaPedido extends StatelessWidget {
  final Map<String, String> pedido;
  final String estado;
  final String producto;
  final VoidCallback onVerDetalle;
  final VoidCallback? onCancelar;

  const TarjetaPedido({
    super.key,
    required this.pedido,
    required this.estado,
    required this.producto,
    required this.onVerDetalle,
    this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    final estadoOriginal = pedido['estado'] ?? '';

    final Color colorEstado = estadoOriginal == 'Entregado'
        ? Colors.greenAccent
        : estadoOriginal == 'Pendiente'
        ? Colors.orangeAccent
        : Colors.redAccent;

    return Card(
      color: AppColors.earthBrown,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    pedido['numero']!,
                    style: const TextStyle(
                      color: AppColors.goldSand,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  estado,
                  style: TextStyle(
                    color: colorEstado,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${texto('fecha')}: ${pedido['fecha']}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(producto, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            Text(
              '${texto('total')}: ${pedido['total']}',
              style: const TextStyle(
                color: AppColors.goldSand,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                spacing: 8,
                children: [
                  if (onCancelar != null)
                    TextButton(
                      onPressed: onCancelar,
                      child: const Text(
                        'Cancelar pedido',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  TextButton(
                    onPressed: onVerDetalle,
                    child: Text(
                      texto('ver_detalle'),
                      style: const TextStyle(color: AppColors.goldSand),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
