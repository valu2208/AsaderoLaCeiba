import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tarjeta_vidrio.dart';

// Colores según el rendimiento (el normal es el crema del vidrio)
const colorRendimientoBien = Color(0xFF7FE0A0);
const colorRendimientoBajo = Color(0xFFFF8A65);

// Leyenda del gráfico: qué significa cada color de las barras
class LeyendaRendimiento extends StatelessWidget {
  const LeyendaRendimiento({super.key});

  Widget _punto(Color color, String texto) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          texto,
          style: GoogleFonts.josefinSans(
            fontSize: 12,
            color: TarjetaVidrio.colorTextoSuave,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _punto(colorRendimientoBien, 'Bien'),
        _punto(TarjetaVidrio.colorTexto, 'Normal'),
        _punto(colorRendimientoBajo, 'Bajo'),
        Text(
          'vs. el promedio del periodo',
          style: GoogleFonts.josefinSans(
            fontSize: 11,
            color: TarjetaVidrio.colorTextoSuave,
          ),
        ),
      ],
    );
  }
}