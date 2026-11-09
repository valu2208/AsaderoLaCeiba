import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';

const _meses = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
];

// Flechas para moverse al día, mes o año anterior o siguiente
class SelectorFecha extends StatelessWidget {
  final String periodo; // 'dia', 'mes' o 'anio'
  final DateTime fecha;
  final ValueChanged<DateTime> onCambio;

  const SelectorFecha({
    super.key,
    required this.periodo,
    required this.fecha,
    required this.onCambio,
  });

  String get _etiqueta {
    if (periodo == 'dia') return '${fecha.day} de ${_meses[fecha.month - 1]} ${fecha.year}';
    if (periodo == 'mes') return '${_meses[fecha.month - 1]} ${fecha.year}';
    return '${fecha.year}';
  }

  // Día, mes o año vecino (delta = -1 o 1)
  DateTime _mover(int delta) {
    if (periodo == 'dia') return DateTime(fecha.year, fecha.month, fecha.day + delta);
    if (periodo == 'mes') return DateTime(fecha.year, fecha.month + delta, 1);
    return DateTime(fecha.year + delta, 1, 1);
  }

  @override
  Widget build(BuildContext context) {
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    final hayAdelante = !_mover(1).isAfter(hoy);

    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            color: AppColors.earthBrown,
            onPressed: () => onCambio(_mover(-1)),
          ),
          Expanded(
            child: Text(
              _etiqueta,
              textAlign: TextAlign.center,
              style: GoogleFonts.josefinSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.asphalt,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            color: AppColors.earthBrown,
            onPressed: hayAdelante ? () => onCambio(_mover(1)) : null,
          ),
        ],
      ),
    );
  }
}