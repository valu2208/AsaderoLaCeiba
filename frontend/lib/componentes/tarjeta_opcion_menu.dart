import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/models/opcion_menu.dart';
import 'package:asadero/componentes/fondo_hero.dart';
import 'package:asadero/componentes/foto_circular.dart';

// Una opción de la pantalla Menú: card con degradado, círculos de adorno y la foto
// del plato "saliéndose" de la card por la derecha
class TarjetaOpcionMenu extends StatelessWidget {
  final OpcionMenu opcion;
  final VoidCallback onTap;

  const TarjetaOpcionMenu({super.key, required this.opcion, required this.onTap});

  Widget _adorno(double diametro, double opacidad) {
    return Container(
      width: diametro,
      height: diametro,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacidad),
      ),
    );
  }

  Widget _textos(double derecha) {
    return Padding(
      padding: EdgeInsets.fromLTRB(22, 0, derecha, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Si el título no cabe, se achica en vez de cortarse
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              opcion.titulo,
              style: GoogleFonts.josefinSans(
                color: AppColors.goldSand,
                fontSize: 27,
                fontWeight: FontWeight.bold,
                shadows: const [Shadow(color: Colors.black38, blurRadius: 6)],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            opcion.descripcion,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.josefinSans(
              color: AppColors.goldSand.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
          // Candado cuando la opción no está disponible hoy
          if (opcion.aviso != null) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 16, color: AppColors.goldSand),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    opcion.aviso!,
                    style: GoogleFonts.josefinSans(
                      color: AppColors.goldSand,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Con candado la card se ve más clara, como "apagada"
    return Opacity(
      opacity: opcion.aviso != null ? 0.6 : 1,
      child: _card(),
    );
  }

  Widget _card() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: LayoutBuilder(
        builder: (context, medidas) {
          final alto = medidas.maxHeight;
          final diametro = alto * 1.06; // la foto sigue el alto de la card
          const sale = 8.0; // cuánto se sale la foto por la derecha

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(child: FondoHero(opcion: opcion)),
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -alto * 0.35,
                        top: -alto * 0.30,
                        child: _adorno(alto * 1.35, 0.10),
                      ),
                      Positioned(
                        left: -alto * 0.25,
                        bottom: -alto * 0.45,
                        child: _adorno(alto * 0.9, 0.07),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: _textos(diametro),
              ),
              Positioned(
                right: -sale,
                top: (alto - diametro) / 2,
                width: diametro,
                height: diametro,
                child: Hero(
                  tag: opcion.heroFoto,
                  child: FotoCircular(imagen: opcion.imagen, icono: opcion.icono),
                ),
              ),
              Positioned.fill(
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: onTap,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}