import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/reporte.dart';
import 'leyenda_rendimiento.dart';
import 'tarjeta_vidrio.dart';

// Gráfico de barras: ventas por hora (día), por día (mes) o por mes (año).
// Cada barra se pinta según le fue comparada con el promedio del periodo.
class GraficoBarras extends StatelessWidget {
  final String periodo;
  final List<PuntoSerie> serie;

  const GraficoBarras({super.key, required this.periodo, required this.serie});

  String get _titulo {
    if (periodo == 'dia') return 'Ventas por hora';
    if (periodo == 'mes') return 'Ventas por día';
    return 'Ventas por mes';
  }

  // Cada cuántas barras se escribe la etiqueta, para que no se amontonen
  int get _paso => serie.length > 24 ? 5 : (serie.length > 12 ? 3 : 1);

  // Promedio de las barras que sí tuvieron ventas (las vacías no cuentan)
  double get _promedio {
    final conVentas = serie.where((p) => p.total > 0).toList();
    if (conVentas.isEmpty) return 0;
    return conVentas.fold<double>(0, (s, p) => s + p.total) / conVentas.length;
  }

  // Bien: 20 % o más sobre el promedio. Bajo: menos del 60 % del promedio.
  Color _colorBarra(double total, double promedio) {
    if (total >= promedio * 1.2) return colorRendimientoBien;
    if (total < promedio * 0.6) return colorRendimientoBajo;
    return TarjetaVidrio.colorTexto;
  }

  Widget _barra(PuntoSerie punto, double maximo, double promedio) {
    final fraccion = maximo <= 0 ? 0.0 : punto.total / maximo;
    final color = punto.total <= 0
        ? TarjetaVidrio.colorTexto.withValues(alpha: 0.35)
        : _colorBarra(punto.total, promedio);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: fraccion.clamp(0.02, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _etiqueta(int indice) {
    return Expanded(
      child: Text(
        indice % _paso == 0 ? serie[indice].etiqueta : '',
        textAlign: TextAlign.center,
        softWrap: false,
        style: GoogleFonts.josefinSans(
          fontSize: 10,
          color: TarjetaVidrio.colorTextoSuave,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maximo = serie.fold<double>(0, (m, p) => p.total > m ? p.total : m);
    final promedio = _promedio;

    return TarjetaVidrio(
      tinte: TarjetaVidrio.tinteCafe,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _titulo,
            style: GoogleFonts.josefinSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: TarjetaVidrio.colorTexto,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [for (final p in serie) _barra(p, maximo, promedio)],
            ),
          ),
          const SizedBox(height: 6),
          Row(children: [for (var i = 0; i < serie.length; i++) _etiqueta(i)]),
          const SizedBox(height: 10),
          const LeyendaRendimiento(),
        ],
      ),
    );
  }
}