import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/reporte.dart';
import 'tarjeta_vidrio.dart';

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
            backgroundColor: TarjetaVidrio.colorTexto.withValues(alpha: 0.2),
            child: Text(
              '$posicion',
              style: GoogleFonts.josefinSans(
                fontWeight: FontWeight.bold,
                color: TarjetaVidrio.colorTexto,
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
                  style: GoogleFonts.josefinSans(
                    fontSize: 15,
                    color: TarjetaVidrio.colorTexto,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: maximo == 0 ? 0 : plato.cantidad / maximo,
                    minHeight: 6,
                    color: TarjetaVidrio.colorTexto,
                    backgroundColor:
                        TarjetaVidrio.colorTexto.withValues(alpha: 0.2),
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
              color: TarjetaVidrio.colorTexto,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maximo = platos.isEmpty ? 0 : platos.first.cantidad;

    return TarjetaVidrio(
      tinte: TarjetaVidrio.tinteCiruela,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Platos más vendidos',
            style: GoogleFonts.josefinSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: TarjetaVidrio.colorTexto,
            ),
          ),
          const SizedBox(height: 6),
          if (platos.isEmpty)
            Text(
              'Sin ventas en este periodo.',
              style: GoogleFonts.josefinSans(
                color: TarjetaVidrio.colorTextoSuave,
              ),
            ),
          for (var i = 0; i < platos.length; i++) _fila(i + 1, platos[i], maximo),
        ],
      ),
    );
  }
}