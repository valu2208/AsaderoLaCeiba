import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/formato.dart';
import '../models/reporte.dart';
import 'tarjeta_vidrio.dart';

// Tarjetas de resumen: total vendido, pedidos y ticket promedio
class ResumenReporte extends StatelessWidget {
  final Reporte reporte;

  const ResumenReporte({super.key, required this.reporte});

  Widget _etiqueta(String texto) {
    return Text(
      texto,
      style: GoogleFonts.josefinSans(
        fontSize: 14,
        color: TarjetaVidrio.colorTexto,
      ),
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
          color: TarjetaVidrio.colorTexto,
        ),
      ),
    );
  }

  Widget _pequena(String titulo, String valor, Color tinte) {
    return Expanded(
      child: TarjetaVidrio(
        tinte: tinte,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_etiqueta(titulo), _cifra(valor, 22)],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TarjetaVidrio(
          tinte: TarjetaVidrio.tinteNaranja,
          child: Column(
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
              _pequena('Pedidos', '${reporte.pedidos}', TarjetaVidrio.tinteRojo),
              _pequena(
                'Ticket promedio',
                formatoPesos(reporte.ticketPromedio),
                TarjetaVidrio.tinteCiruela,
              ),
            ],
          ),
        ),
      ],
    );
  }
}