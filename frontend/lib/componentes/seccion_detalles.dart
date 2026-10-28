import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';

// Chip "Detalles" + descripción del plato.
// Si el texto es largo se recorta y aparece "Ver más" (o se toca el chip);
// si es corto se muestra completo y el chip es solo un título.
class SeccionDetalles extends StatefulWidget {
  final String texto;
  final int lineasMax; // líneas que se ven antes de recortar

  const SeccionDetalles({super.key, required this.texto, this.lineasMax = 3});

  @override
  State<SeccionDetalles> createState() => _SeccionDetallesState();
}

class _SeccionDetallesState extends State<SeccionDetalles> {
  bool _abierto = false;

  final TextStyle _estilo = GoogleFonts.josefinSans(
    color: AppColors.earthBrown,
    fontSize: 17,
    height: 1.5,
  );

  // Mide el texto: ¿se pasa de las líneas permitidas con este ancho?
  bool _esLargo(double ancho) {
    final medidor = TextPainter(
      text: TextSpan(text: widget.texto, style: _estilo),
      maxLines: widget.lineasMax,
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.textScalerOf(context),
    )..layout(maxWidth: ancho);

    return medidor.didExceedMaxLines;
  }

  void _cambiar() => setState(() => _abierto = !_abierto);

  Widget _chip(bool largo) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: largo ? _cambiar : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.demonicPresence,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Detalles',
              style: GoogleFonts.josefinSans(
                color: AppColors.goldSand,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (largo)
              Icon(
                _abierto ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: AppColors.goldSand,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, medidas) {
        final largo = _esLargo(medidas.maxWidth);
        final recortado = largo && !_abierto;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _chip(largo),
            const SizedBox(height: 14),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              alignment: Alignment.topCenter,
              child: Text(
                widget.texto,
                maxLines: recortado ? widget.lineasMax : null,
                overflow: recortado ? TextOverflow.ellipsis : TextOverflow.visible,
                style: _estilo,
              ),
            ),
            if (largo)
              TextButton(
                onPressed: _cambiar,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  foregroundColor: AppColors.redPrayerFlag,
                ),
                child: Text(
                  _abierto ? 'Ver menos' : 'Ver más',
                  style: GoogleFonts.josefinSans(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
          ],
        );
      },
    );
  }
}