import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import '../models/reporte.dart';

// Platos más vendidos del periodo, del que más salió al que menos
class ListaMasVendidos extends StatelessWidget {
  final List<PlatoVendido> platos;

  const ListaMasVendidos({super.key, required this.platos});

  Widget _fila(int posicion, PlatoVendido plato, int maximo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.redPrayerFlag.withValues(alpha: 0.12),
            child: Text(
              '$posicion',
              style: GoogleFonts.josefinSans(
                fontWeight: FontWeight.bold,
                color: AppColors.redPrayerFlag,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plato.nombre,
                  style: GoogleFonts.josefinSans(fontSize: 15, color: AppColors.asphalt),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: maximo == 0 ? 0 : plato.cantidad / maximo,
                    minHeight: 6,
                    color: AppColors.redPrayerFlag,
                    backgroundColor: AppColors.earthBrown.withValues(alpha: 0.12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${plato.cantidad} uds',
            style: GoogleFonts.josefinSans(
              fontWeight: FontWeight.bold,
              color: AppColors.earthBrown,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maximo = platos.isEmpty ? 0 : platos.first.cantidad;

    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Platos más vendidos',
              style: GoogleFonts.josefinSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.asphalt,
              ),
            ),
            const SizedBox(height: 6),
            if (platos.isEmpty)
              Text(
                'Sin ventas en este periodo.',
                style: GoogleFonts.josefinSans(color: AppColors.earthBrown),
              ),
            for (var i = 0; i < platos.length; i++) _fila(i + 1, platos[i], maximo),
          ],
        ),
      ),
    );
  }
}