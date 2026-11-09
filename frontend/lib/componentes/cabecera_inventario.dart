import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import '../models/ingrediente.dart';
import 'filtro_chips.dart';

// Parte de arriba del inventario: tarjetas de resumen y filtros
class CabeceraInventario extends StatelessWidget {
  final Future<List<Ingrediente>> ingredientes;
  final String filtro;
  final ValueChanged<String> onFiltro;

  const CabeceraInventario({
    super.key,
    required this.ingredientes,
    required this.filtro,
    required this.onFiltro,
  });

  static const _filtros = {
    'todos': 'Todos',
    'bajos': 'Stock bajo',
    'ok': 'Al día',
  };

  Widget _tarjeta(IconData icono, String titulo, int valor, Color color) {
    return Expanded(
      child: Card(
        color: Colors.white,
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(icono, size: 18, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                '$valor',
                style: GoogleFonts.josefinSans(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.asphalt,
                ),
              ),
              Text(
                titulo,
                style: GoogleFonts.josefinSans(fontSize: 13, color: AppColors.earthBrown),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<Ingrediente>>(
          future: ingredientes,
          builder: (context, snapshot) {
            final lista = snapshot.data ?? <Ingrediente>[];
            final bajos = lista.where((i) => i.bajo).length;
            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  _tarjeta(Icons.inventory_2, 'Ingredientes', lista.length, AppColors.earthBrown),
                  _tarjeta(Icons.warning_amber_rounded, 'Stock bajo', bajos, AppColors.redPrayerFlag),
                  _tarjeta(Icons.check_circle_outline, 'Al día', lista.length - bajos, Colors.green.shade700),
                ],
              ),
            );
          },
        ),
        FiltroChips(opciones: _filtros, seleccionado: filtro, onCambio: onFiltro),
      ],
    );
  }
}