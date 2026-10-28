import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';

// Una opción de la pantalla Menú: texto a la izquierda y el plato a la derecha,
// cortado por el borde de la card
class TarjetaOpcionMenu extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final String imagen; // ruta de la foto en assets/imagenes/
  final IconData icono; // se muestra si la foto no existe
  final Color color;
  final VoidCallback onTap;

  const TarjetaOpcionMenu({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.imagen,
    required this.icono,
    required this.color,
    required this.onTap,
  });

  Widget _foto(double diametro) {
    final respaldo = Container(
      color: AppColors.earthBrown,
      child: Icon(icono, size: diametro * 0.4, color: AppColors.goldSand),
    );

    return Container(
      width: diametro,
      height: diametro,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(-2, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          imagen,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => respaldo,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Material(
        color: color,
        elevation: 6,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: LayoutBuilder(
            builder: (context, medidas) {
              final diametro = medidas.maxHeight * 1.08; // la foto sigue el alto de la card
              final visible = diametro * 0.72; // parte de la foto que se ve
              return Stack(
                children: [
                  Positioned(
                    right: -(diametro - visible),
                    top: (medidas.maxHeight - diametro) / 2,
                    child: _foto(diametro),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(22, 0, visible + 8, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titulo,
                            style: GoogleFonts.josefinSans(
                              color: AppColors.goldSand,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            descripcion,
                            style: GoogleFonts.josefinSans(
                              color: AppColors.goldSand.withValues(alpha: 0.85),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}