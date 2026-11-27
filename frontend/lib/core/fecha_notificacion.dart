import 'package:asadero/core/traducciones.dart';

// "Hoy 14:05" si es de hoy, o "26/11/2026" si es de otro día
String formatearFechaNotificacion(dynamic fecha) {
  if (fecha == null) return '';

  final date = DateTime.tryParse(fecha.toString());
  if (date == null) return '';

  final local = date.toLocal();
  final ahora = DateTime.now();
  String dos(int n) => n.toString().padLeft(2, '0');

  if (local.year == ahora.year &&
      local.month == ahora.month &&
      local.day == ahora.day) {
    return '${texto('hoy')} ${dos(local.hour)}:${dos(local.minute)}';
  }

  return '${dos(local.day)}/${dos(local.month)}/${local.year}';
}