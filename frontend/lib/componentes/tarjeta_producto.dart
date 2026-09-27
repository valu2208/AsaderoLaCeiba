import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

class TarjetaProducto extends StatefulWidget {
  final String nombre;
  final String precio;
  final String imagen;
  final VoidCallback onInformacion;

  const TarjetaProducto({
    super.key,
    required this.nombre,
    required this.precio,
    required this.imagen,
    required this.onInformacion,
  });

  @override
  State<TarjetaProducto> createState() => _TarjetaProductoState();
}

class _TarjetaProductoState extends State<TarjetaProducto> {
  int cantidad = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _cuerpo(),
        _imagenFlotante(),
      ],
    );
  }

  Widget _cuerpo() {
    return Container(
      margin: const EdgeInsets.only(top: 34),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.earthBrown,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 76, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.nombre,
            maxLines: 2,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          _filaAcciones(),
        ],
      ),
    );
  }

  Widget _filaAcciones() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: widget.onInformacion,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 30),
          ),
          child: const Text(
            'Más información',
            style: TextStyle(
              color: AppColors.goldSand,
              fontSize: 11,
            ),
          ),
        ),
        Row(
          children: [
            if (cantidad > 0)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  '$cantidad',
                  style: const TextStyle(
                    color: AppColors.goldSand,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            IconButton(
              onPressed: () {
                setState(() {
                  cantidad++;
                });
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.add_circle,
                color: AppColors.redPrayerFlag,
                size: 22,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _imagenFlotante() {
    return Positioned(
      top: 0,
      left: 10,
      right: 10,
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(
            widget.imagen,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}