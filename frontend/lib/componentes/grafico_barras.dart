import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import '../models/reporte.dart';

// Gráfico de barras: ventas por hora (día), por día (mes) o por mes (año)
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

  Widget _barra(PuntoSerie punto, double maximo) {
    final fraccion = maximo <= 0 ? 0.0 : punto.total / maximo;
    final esMaxima = maximo > 0 && punto.total == maximo;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: fraccion.clamp(0.02, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: esMaxima
                    ? AppColors.redPrayerFlag
                    : AppColors.earthBrown.withValues(alpha: 0.35),
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
        style: GoogleFonts.josefinSans(fontSize: 10, color: AppColors.earthBrown),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maximo = serie.fold<double>(0, (m, p) => p.total > m ? p.total : m);

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
              _titulo,
              style: GoogleFonts.josefinSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.asphalt,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [for (final p in serie) _barra(p, maximo)],
              ),
            ),
            const SizedBox(height: 6),
            Row(children: [for (var i = 0; i < serie.length; i++) _etiqueta(i)]),
          ],
        ),
      ),
    );
  }
}