import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/color_estado.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/formato.dart';
import '../componentes/tarjeta_item_pedido.dart';
import '../models/pedido_personal.dart';

// Detalle de un pedido para el mesero y la cocina: platos con foto, mesa,
// notas y el mismo botón de acción que tiene la card.
class DetallePedidoPersonal extends StatelessWidget {
  final PedidoPersonal pedido;
  final String? accion; // texto del botón (null = sin botón)
  final VoidCallback? onAccion;

  const DetallePedidoPersonal({
    super.key,
    required this.pedido,
    this.accion,
    this.onAccion,
  });

  TextStyle _estilo(double size, Color color, {bool negrita = false}) {
    return GoogleFonts.josefinSans(
      color: color,
      fontSize: size,
      fontWeight: negrita ? FontWeight.bold : FontWeight.normal,
    );
  }

  Widget _estado() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: colorEstado(pedido.estado),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          pedido.estado,
          style: _estilo(15, AppColors.earthBrown, negrita: true),
        ),
      ],
    );
  }

  Widget _mesa() {
    if (pedido.mesa == null) {
      return Text(
        'Mesa por asignar',
        style: _estilo(16, AppColors.earthBrown),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.demonicPresence,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.table_restaurant, color: AppColors.goldSand),
          const SizedBox(width: 8),
          Text(
            'Mesa ${pedido.mesa}',
            style: _estilo(20, AppColors.goldSand, negrita: true),
          ),
        ],
      ),
    );
  }

  Widget _notas() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.earthBrown.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        'Nota: ${pedido.notas}',
        style: _estilo(16, AppColors.earthBrown),
      ),
    );
  }

  Widget _boton(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.demonicPresence,
              foregroundColor: AppColors.goldSand,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
            ),
            onPressed: onAccion == null
                ? null
                : () {
                    Navigator.pop(context);
                    onAccion!();
                  },
            child: Text(
              accion!,
              style: GoogleFonts.josefinSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldSand,
      appBar: AppBar(
        title: Text(
          'Pedido #${pedido.id}',
          style: GoogleFonts.kronaOne(fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: AppColors.earthBrown,
        foregroundColor: AppColors.goldSand,
      ),
      bottomNavigationBar: accion == null ? null : _boton(context),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${pedido.cliente} · ${pedido.hace}',
                  style: _estilo(16, AppColors.earthBrown),
                ),
              ),
              _estado(),
            ],
          ),
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerLeft, child: _mesa()),
          const SizedBox(height: 16),
          for (final item in pedido.items) TarjetaItemPedido(item: item),
          if (pedido.notas.isNotEmpty) _notas(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: _estilo(20, AppColors.asphalt, negrita: true)),
              Text(
                formatoPesos(pedido.total),
                style: _estilo(24, AppColors.redPrayerFlag, negrita: true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}