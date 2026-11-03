import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/formato.dart';
import '../models/pedido_personal.dart';

// Card de un pedido para el mesero y la cocina (mismos colores de las cards del cliente)
class TarjetaPedidoPersonal extends StatelessWidget {
  final PedidoPersonal pedido;
  final String? accion; // texto del botón (null = sin botón)
  final VoidCallback? onAccion;
  final bool ocupado; // true = botón desactivado mientras se envía

  const TarjetaPedidoPersonal({
    super.key,
    required this.pedido,
    this.accion,
    this.onAccion,
    this.ocupado = false,
  });

  Widget _linea(String texto, {double size = 14, bool negrita = false, double opacidad = 1}) {
    return Text(
      texto,
      style: GoogleFonts.josefinSans(
        color: AppColors.goldSand.withValues(alpha: opacidad),
        fontSize: size,
        fontWeight: negrita ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _estado() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.goldSand),
        borderRadius: BorderRadius.circular(12),
      ),
      child: _linea(pedido.estado, size: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.demonicPresence,
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: _linea('Pedido #${pedido.id}', size: 18, negrita: true)),
                _estado(),
              ],
            ),
            _linea('${pedido.cliente} · ${pedido.hace}', opacidad: 0.8),
            Divider(color: AppColors.goldSand.withValues(alpha: 0.25), height: 20),
            for (final item in pedido.items)
              _linea('${item.cantidad} × ${item.nombre}', size: 16),
            if (pedido.notas.isNotEmpty) ...[
              const SizedBox(height: 6),
              _linea('Nota: ${pedido.notas}', opacidad: 0.85),
            ],
            const SizedBox(height: 8),
            _linea('Total ${formatoPesos(pedido.total)}', negrita: true),
            if (accion != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldSand,
                    foregroundColor: AppColors.demonicPresence,
                  ),
                  onPressed: ocupado ? null : onAccion,
                  child: Text(accion!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}