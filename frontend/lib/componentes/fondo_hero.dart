import 'package:flutter/material.dart';
import 'package:asadero/models/opcion_menu.dart';

// Fondo de color de una opción del Menú. Es un Hero: al tocar la card, el fondo
// crece y se convierte en la barra de arriba de esa categoría (y al volver, al revés)
class FondoHero extends StatelessWidget {
  final OpcionMenu opcion;
  final bool esBanner; // true = barra de arriba, false = card del menú

  const FondoHero({super.key, required this.opcion, this.esBanner = false});

  static const _radioCard = BorderRadius.all(Radius.circular(24));
  static const _radioBanner = BorderRadius.vertical(bottom: Radius.circular(32));

  BoxDecoration _decoracion(BorderRadius radio) {
    return BoxDecoration(
      gradient: opcion.degradado,
      borderRadius: radio,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.28),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: opcion.heroFondo,
      // Durante el vuelo, las esquinas pasan poco a poco de una forma a la otra
      flightShuttleBuilder: (context, animacion, direccion, desde, hasta) {
        final entrando = direccion == HeroFlightDirection.push;
        return AnimatedBuilder(
          animation: animacion,
          builder: (context, hijo) {
            final radio = BorderRadius.lerp(
              entrando ? _radioCard : _radioBanner,
              entrando ? _radioBanner : _radioCard,
              animacion.value,
            )!;
            return DecoratedBox(decoration: _decoracion(radio));
          },
        );
      },
      child: DecoratedBox(
        decoration: _decoracion(esBanner ? _radioBanner : _radioCard),
      ),
    );
  }
}