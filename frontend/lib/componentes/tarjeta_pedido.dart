import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';

class TarjetaPedido extends StatelessWidget {
  final Map<String, String> pedido;
  final String estado;
  final String producto;
  final VoidCallback onVerDetalle;
  final VoidCallback? onPagar; // solo cuando ya se puede pagar

  const TarjetaPedido({
    super.key,
    required this.pedido,
    required this.estado,
    required this.producto,
    required this.onVerDetalle,
    this.onPagar,
  });

  // Texto y color del estado del pago (vacío si todavía no hay comprobante).
  (String, Color)? _pago() {
    switch (pedido['estado_pago']) {
      case 'Pendiente':
        return (texto('pago_revision'), Colors.orangeAccent);
      case 'Aprobado':
        return (texto('pago_aprobado'), Colors.greenAccent);
      case 'Rechazado':
        return (texto('pago_rechazado'), Colors.redAccent);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final original = pedido['estado'] ?? '';
    final colorEstado = original == 'Entregado'
        ? Colors.greenAccent
        : original == 'Pendiente'
            ? Colors.orangeAccent
            : Colors.redAccent;
    final pago = _pago();

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
            Row(children: [
              Expanded(
                child: Text(
                  pedido['numero']!,
                  style: const TextStyle(
                      color: AppColors.goldSand,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(estado,
                  style: TextStyle(
                      color: colorEstado, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 10),
            Text(
              '${texto('fecha')}: ${pedido['fecha']}'
              '${pedido['mesa'] == null ? '' : '  ·  ${texto('mesa')} ${pedido['mesa']}'}',
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
                  fontSize: 16),
            ),
            if (pago != null) ...[
              const SizedBox(height: 6),
              Text(pago.$1,
                  style: TextStyle(color: pago.$2, fontWeight: FontWeight.bold)),
            ],
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(spacing: 8, children: [
                if (onPagar != null)
                  ElevatedButton.icon(
                    onPressed: onPagar,
                    icon: const Icon(Icons.qr_code, size: 18),
                    label: Text(texto('pagar_cuenta')),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.redPrayerFlag,
                        foregroundColor: Colors.white),
                  ),
                TextButton(
                  onPressed: onVerDetalle,
                  child: Text(texto('ver_detalle'),
                      style: const TextStyle(color: AppColors.goldSand)),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}