import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import '../models/ingrediente.dart';

// Card de un ingrediente: cantidad, mínimo y una barra que se acorta cuando falta
class TarjetaIngrediente extends StatelessWidget {
  final Ingrediente ingrediente;
  final VoidCallback onTap;

  const TarjetaIngrediente({super.key, required this.ingrediente, required this.onTap});

  Widget _texto(String valor, {double size = 14, bool negrita = false, double opacidad = 1}) {
    return Text(
      valor,
      style: GoogleFonts.josefinSans(
        color: AppColors.goldSand.withValues(alpha: opacidad),
        fontSize: size,
        fontWeight: negrita ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final i = ingrediente;
    // La barra llena es el doble del mínimo: así se ve cuándo se está acabando
    final nivel = i.stockMinimo <= 0 ? 1.0 : (i.stockActual / (i.stockMinimo * 2)).clamp(0.0, 1.0);

    return Card(
      color: AppColors.demonicPresence,
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: _texto(i.nombre, size: 18, negrita: true)),
                  if (i.bajo) ...[
                    const Icon(Icons.warning_amber_rounded, color: AppColors.goldSand, size: 20),
                    const SizedBox(width: 4),
                    _texto('Bajo', negrita: true),
                  ],
                  const SizedBox(width: 8),
                  const Icon(Icons.edit_outlined, color: AppColors.goldSand, size: 20),
                ],
              ),
              const SizedBox(height: 6),
              _texto('Hay ${i.stockActual} ${i.unidad}', size: 16),
              _texto('Mínimo: ${i.stockMinimo} ${i.unidad}', opacidad: 0.8),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: nivel,
                  minHeight: 8,
                  color: AppColors.goldSand,
                  backgroundColor: AppColors.goldSand.withValues(alpha: 0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}