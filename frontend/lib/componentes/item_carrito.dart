import 'package:flutter/material.dart';
import 'package:asadero/componentes/imagen_adaptable.dart';
import 'package:asadero/core/carrito_estado.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/core/traducciones.dart';

class ItemCarrito extends StatelessWidget {
  final CarritoItem item;
  final bool bloqueado;

  const ItemCarrito({super.key, required this.item, this.bloqueado = false});

  String _nombre() {
    final idioma = Idioma.seleccionado.value;
    if (idioma == 'English' && (item.nombreEn ?? '').isNotEmpty) {
      return item.nombreEn!;
    }
    if (idioma == 'Português' && (item.nombrePt ?? '').isNotEmpty) {
      return item.nombrePt!;
    }
    return item.nombre;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.fondoComponentes,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ImagenAdaptable(ruta: item.imagen, ancho: 55, alto: 55),
        ),
        title: Text(
          _nombre(),
          style: const TextStyle(
            color: AppColors.goldSand,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${item.precio}\n${texto('cantidad')}: ${item.cantidad}',
          style: const TextStyle(color: Colors.white),
        ),
        trailing: IconButton(
          tooltip: texto('eliminar_producto'),
          icon: const Icon(Icons.delete_outline, color: AppColors.goldSand),
          onPressed: bloqueado ? null : () => CarritoEstado.eliminar(item.nombre),
        ),
      ),
    );
  }
}