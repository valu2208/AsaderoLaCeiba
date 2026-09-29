import 'package:flutter/material.dart';

class ImagenProducto extends StatelessWidget {
  final String imagen;
  final double alto;

  const ImagenProducto({
    super.key,
    required this.imagen,
    required this.alto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: alto,
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
          imagen,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}