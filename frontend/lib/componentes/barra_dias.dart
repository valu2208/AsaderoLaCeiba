import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/dias_semana.dart';

// Chips de los días de la semana (diseño "Gestión del Menú" de Figma)
class BarraDias extends StatelessWidget {
  final String seleccionado;
  final ValueChanged<String> onCambio;
  final List<String> dias; // por defecto solo de lunes a viernes

  const BarraDias({
    super.key,
    required this.seleccionado,
    required this.onCambio,
    this.dias = diasEntreSemana,
  });

  // Del crema al rosado, un tono más por cada día
  Color _color(int indice) {
    final fin = dias.length > 1 ? dias.length - 1 : 1;
    return Color.lerp(AppColors.goldSand, const Color(0xFFF2677A), indice / fin)!;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: dias.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, indice) {
          final dia = dias[indice];
          final activo = dia == seleccionado;

          return GestureDetector(
            onTap: () => onCambio(dia),
            child: Container(
              padding: const EdgeInsets.only(left: 14, right: 6),
              decoration: BoxDecoration(
                color: _color(indice),
                borderRadius: BorderRadius.circular(20),
                border: activo ? Border.all(color: AppColors.asphalt, width: 2) : null,
              ),
              child: Row(
                children: [
                  Text(
                    nombresDias[dia]!,
                    style: GoogleFonts.josefinSans(
                      color: AppColors.asphalt,
                      fontSize: 15,
                      fontWeight: activo ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  Icon(
                    activo ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                    color: AppColors.asphalt,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}