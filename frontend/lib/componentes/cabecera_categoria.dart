import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/carrito_estado.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/models/opcion_menu.dart';
import 'package:asadero/componentes/fondo_hero.dart';
import 'package:asadero/componentes/foto_circular.dart';
import 'package:asadero/pantallas/carrito.dart';

// Barra de arriba de una categoría: el mismo color y la misma foto de la card
// (llegan con una animación), el nombre, volver y el carrito
class CabeceraCategoria extends StatelessWidget {
  final OpcionMenu opcion;

  const CabeceraCategoria({super.key, required this.opcion});

  Widget _boton(Widget icono, VoidCallback alPulsar) {
    return Material(
      color: Colors.black.withValues(alpha: 0.28),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: alPulsar,
        child: SizedBox(width: 42, height: 42, child: Center(child: icono)),
      ),
    );
  }

  Widget _carrito(BuildContext context) {
    return ValueListenableBuilder<List<CarritoItem>>(
      valueListenable: CarritoEstado.items,
      builder: (context, items, hijo) {
        final total = CarritoEstado.total;
        return _boton(
          Badge(
            isLabelVisible: total > 0,
            label: Text('$total'),
            backgroundColor: AppColors.goldSand,
            textColor: AppColors.demonicPresence,
            child: const Icon(Icons.shopping_cart_outlined, color: AppColors.goldSand),
          ),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const Carrito()),
          ),
        );
      },
    );
  }

  // El nombre aparece cuando la animación ya casi terminó
  Widget _textos(BuildContext context) {
    final animacion = ModalRoute.of(context)?.animation ?? kAlwaysCompleteAnimation;
    return FadeTransition(
      opacity: animacion.drive(CurveTween(curve: const Interval(0.55, 1.0, curve: Curves.easeOut))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              opcion.titulo,
              style: GoogleFonts.josefinSans(
                color: AppColors.goldSand,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                shadows: const [Shadow(color: Colors.black38, blurRadius: 6)],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            opcion.descripcion,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.josefinSans(
              color: AppColors.goldSand.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arriba = MediaQuery.of(context).padding.top;
    const diametro = 168.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SizedBox(
        height: arriba + 210,
        child: Stack(
          children: [
            Positioned.fill(child: FondoHero(opcion: opcion, esBanner: true)),
            Positioned(
              right: -22,
              top: arriba + 36,
              width: diametro,
              height: diametro,
              child: Hero(
                tag: opcion.heroFoto,
                child: FotoCircular(imagen: opcion.imagen, icono: opcion.icono),
              ),
            ),
            Positioned(
              left: 6,
              top: arriba + 6,
              child: _boton(
                const Icon(Icons.arrow_back, color: AppColors.goldSand),
                () => Navigator.pop(context),
              ),
            ),
            Positioned(right: 10, top: arriba + 6, child: _carrito(context)),
            Positioned(
              left: 24,
              right: diametro - 10,
              bottom: 26,
              child: _textos(context),
            ),
          ],
        ),
      ),
    );
  }
}