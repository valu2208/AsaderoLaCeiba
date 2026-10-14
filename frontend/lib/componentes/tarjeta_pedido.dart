import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';

class TarjetaPedido extends StatelessWidget {
  final Map<String, String> pedido;
  final String estado;
  final String producto;
  final VoidCallback onVerDetalle;

  const TarjetaPedido({
    super.key,
    required this.pedido,
    required this.estado,
    required this.producto,
    required this.onVerDetalle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.asphalt,
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
                    color: pedido['estado'] == 'Entregado'
                        ? Colors.greenAccent
                        : Colors.redAccent,
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
              child: TextButton(
                onPressed: onVerDetalle,
                child: Text(
                  texto('ver_detalle'),
                  style: const TextStyle(color: AppColors.goldSand),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
