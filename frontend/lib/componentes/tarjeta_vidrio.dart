import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

// Tarjeta translúcida (efecto vidrio) para pantallas con fondo degradado.
// Oscura (por defecto): texto crema; se puede teñir con un color (tinte).
// Clara (claro: true): blanco translúcido con texto oscuro, para listas largas.
// En ambas el texto se lee en todo el degradado.
class TarjetaVidrio extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final bool claro;
  final Color? tinte; // color del vidrio oscuro; sin tinte es café casi negro

  const TarjetaVidrio({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.padding = const EdgeInsets.all(16),
    this.claro = false,
    this.tinte,
  });

  // Tintes con los tonos de las tarjetas del menú (oscuros para leer el texto)
  static const Color tinteNaranja = Color(0xFF9E3B0E);
  static const Color tinteRojo = Color(0xFFA31414);
  static const Color tinteCiruela = Color(0xFF86255C);
  static const Color tinteCafe = Color(0xFF4A1F12);

  // Colores para usar sobre el vidrio oscuro
  static const Color colorTexto = AppColors.goldSand;
  static final Color colorTextoSuave = AppColors.goldSand.withValues(alpha: 0.85);

  // Colores para usar sobre el vidrio claro
  static const Color colorTextoOscuro = AppColors.asphalt;
  static final Color colorTextoOscuroSuave = AppColors.asphalt.withValues(alpha: 0.8);

  List<Color> get _colores {
    if (claro) {
      return [
        Colors.white.withValues(alpha: 0.50),
        Colors.white.withValues(alpha: 0.34),
      ];
    }
    final base = tinte ?? AppColors.asphalt;
    final a1 = tinte == null ? 0.58 : 0.80;
    final a2 = tinte == null ? 0.68 : 0.88;
    return [
      base.withValues(alpha: a1),
      Color.lerp(base, Colors.black, 0.28)!.withValues(alpha: a2),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final borde = claro
        ? Colors.white.withValues(alpha: 0.6)
        : AppColors.goldSand.withValues(alpha: 0.35);

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borde),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _colores,
        ),
      ),
      child: child,
    );
  }
}