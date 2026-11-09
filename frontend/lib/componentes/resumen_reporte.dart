import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/formato.dart';
import '../models/reporte.dart';

// Tarjetas de resumen: total vendido, pedidos y ticket promedio
class ResumenReporte extends StatelessWidget {
  final Reporte reporte;

  const ResumenReporte({super.key, required this.reporte});

  Widget _tarjeta({required Widget hijo}) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(padding: const EdgeInsets.all(16), child: hijo),
    );
  }

  Widget _etiqueta(String texto) {
    return Text(
      texto,
      style: GoogleFonts.josefinSans(fontSize: 14, color: AppColors.earthBrown),
    );
  }

  Widget _cifra(String texto, double size) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        texto,
        style: GoogleFonts.josefinSans(
          fontSize: size,
          fontWeight: FontWeight.bold,
          color: AppColors.asphalt,
        ),
      ),
    );
  }

  Widget _pequena(String titulo, String valor) {
    return Expanded(
      child: Card(
        color: Colors.white,
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_etiqueta(titulo), _cifra(valor, 22)],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _tarjeta(
          hijo: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _etiqueta('Total vendido'),
              _cifra(formatoPesos(reporte.total), 34),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              _pequena('Pedidos', '${reporte.pedidos}'),
              _pequena('Ticket promedio', formatoPesos(reporte.ticketPromedio)),
            ],
          ),
        ),
      ],
    );
  }
}