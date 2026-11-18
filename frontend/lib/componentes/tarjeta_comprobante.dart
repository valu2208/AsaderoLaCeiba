import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/visor_imagen.dart';

class TarjetaComprobante extends StatelessWidget {
  final Map<String, dynamic> pago;
  final bool ocupado;
  final VoidCallback onAprobar;
  final VoidCallback onRechazar;

  const TarjetaComprobante({
    super.key,
    required this.pago,
    required this.onAprobar,
    required this.onRechazar,
    this.ocupado = false,
  });

  void _ampliar(BuildContext context, String url) => verFoto(context, url);

  @override
  Widget build(BuildContext context) {
    final url = pago['comprobante_pago_url']?.toString() ?? '';
    final mesa = pago['numero_mesa'];
    final total = double.tryParse('${pago['total']}') ?? 0;
    final formato = total.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.');

    return Card(
      color: AppColors.earthBrown,
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pedido #${pago['id']}${mesa == null ? '' : ' · Mesa $mesa'}',
              style: const TextStyle(
                  color: AppColors.goldSand,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('${pago['cliente'] ?? 'Cliente'} · \$$formato',
                style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 10),
            if (url.isNotEmpty)
              GestureDetector(
                onTap: () => _ampliar(context, url),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(url,
                      height: 200, width: double.infinity, fit: BoxFit.cover),
                ),
              ),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: ocupado ? null : onRechazar,
                  child: const Text('Rechazar',
                      style: TextStyle(color: Colors.redAccent)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: ocupado ? null : onAprobar,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white),
                  child: const Text('Aprobar'),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}