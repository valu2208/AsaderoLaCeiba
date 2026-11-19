import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/formato.dart';
import 'package:asadero/componentes/imagen_adaptable.dart';
import 'package:asadero/componentes/visor_imagen.dart';
import '../models/pedido_personal.dart';

// Un plato del pedido: foto grande (se amplía al tocarla), cantidad, nombre,
// precio y descripción
class TarjetaItemPedido extends StatelessWidget {
  final ItemPedido item;

  const TarjetaItemPedido({super.key, required this.item});

  TextStyle _estilo(double size, Color color, {bool negrita = false}) {
    return GoogleFonts.josefinSans(
      color: color,
      fontSize: size,
      fontWeight: negrita ? FontWeight.bold : FontWeight.normal,
    );
  }

  Widget _foto() {
    final ruta = item.imagen ?? '';

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FotoAmpliable(ruta: ruta, child: ImagenAdaptable(ruta: ruta)),
          if (ruta.isNotEmpty)
            Positioned(
              right: 10,
              bottom: 10,
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.zoom_in, color: Colors.white, size: 22),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _cantidad() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.demonicPresence,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        '× ${item.cantidad}',
        style: _estilo(16, AppColors.goldSand, negrita: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withValues(alpha: 0.55),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _foto(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.nombre,
                        style: _estilo(22, AppColors.asphalt, negrita: true),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      formatoPesos(item.precio),
                      style: _estilo(20, AppColors.redPrayerFlag, negrita: true),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _cantidad(),
                if (item.descripcion.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    item.descripcion,
                    style: _estilo(16, AppColors.earthBrown),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}