import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/formato.dart';
import 'package:asadero/models/producto_model.dart';

// Card de un producto en el panel admin (mismos colores de la card del cliente)
class TarjetaAdminProducto extends StatelessWidget {
  final ProductoModel producto;
  final ValueChanged<String> onAccion; // 'editar', 'estado' o 'eliminar'

  const TarjetaAdminProducto({
    super.key,
    required this.producto,
    required this.onAccion,
  });

  Widget _foto() {
    final url = producto.imagenUrl;
    final vacia = Container(
      width: 70,
      height: 70,
      color: AppColors.earthBrown,
      child: const Icon(Icons.fastfood, color: AppColors.goldSand),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: (url == null || url.isEmpty)
          ? vacia
          : Image.network(
              url,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => vacia,
            ),
    );
  }

  Widget _texto(String valor, {double size = 13, bool negrita = false, int? lineas}) {
    return Text(
      valor,
      maxLines: lineas,
      overflow: lineas == null ? null : TextOverflow.ellipsis,
      style: GoogleFonts.josefinSans(
        color: AppColors.goldSand,
        fontSize: size,
        fontWeight: negrita ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: producto.activo ? 1 : 0.6,
      child: Card(
        color: AppColors.demonicPresence,
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _foto(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _texto(producto.nombre, size: 16, negrita: true),
                    _texto(formatoPesos(producto.precio), negrita: true),
                    _texto(producto.descripcion, lineas: 2),
                    _texto(producto.activo ? 'Activo' : 'Inactivo', size: 12),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                iconColor: AppColors.goldSand,
                color: AppColors.goldSand,
                onSelected: onAccion,
                itemBuilder: (_) => [
                  if (producto.activo)
                    const PopupMenuItem(value: 'editar', child: Text('Editar')),
                  PopupMenuItem(
                    value: 'estado',
                    child: Text(producto.activo ? 'Desactivar' : 'Reactivar'),
                  ),
                  const PopupMenuItem(
                    value: 'eliminar',
                    child: Text('Eliminar definitivamente'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}