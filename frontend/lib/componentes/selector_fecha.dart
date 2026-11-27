import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tarjeta_vidrio.dart';

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

  // Calendario para elegir la fecha directamente
  Future<void> _abrirCalendario(BuildContext context) async {
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);

    final elegida = await showDatePicker(
      context: context,
      initialDate: fecha.isAfter(hoy) ? hoy : fecha,
      firstDate: DateTime(2024),
      lastDate: hoy,
      initialDatePickerMode:
          periodo == 'anio' ? DatePickerMode.year : DatePickerMode.day,
      helpText: periodo == 'mes' ? 'Elige un día del mes' : null,
    );
    if (elegida == null) return;

    if (periodo == 'mes') {
      onCambio(DateTime(elegida.year, elegida.month, 1));
    } else if (periodo == 'anio') {
      onCambio(DateTime(elegida.year, 1, 1));
    } else {
      onCambio(DateTime(elegida.year, elegida.month, elegida.day));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    final hayAdelante = !_mover(1).isAfter(hoy);

    return TarjetaVidrio(
      tinte: TarjetaVidrio.tinteCafe,
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            color: TarjetaVidrio.colorTexto,
            onPressed: () => onCambio(_mover(-1)),
          ),
          Expanded(
            child: InkWell(
              onTap: () => _abrirCalendario(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        _etiqueta,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.josefinSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: TarjetaVidrio.colorTexto,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.calendar_month,
                      size: 20,
                      color: TarjetaVidrio.colorTexto,
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            color: TarjetaVidrio.colorTexto,
            disabledColor: TarjetaVidrio.colorTexto.withValues(alpha: 0.3),
            onPressed: hayAdelante ? () => onCambio(_mover(1)) : null,
          ),
        ],
      ),
    );
  }
}