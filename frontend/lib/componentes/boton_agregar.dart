import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

// Botones de la card: "+" agrega al carrito y "−" quita (aparece cuando ya hay alguno)
class BotonAgregar extends StatelessWidget {
  final int cantidad;
  final VoidCallback onAgregar;
  final VoidCallback? onRestar;

  const BotonAgregar({
    super.key,
    required this.cantidad,
    required this.onAgregar,
    this.onRestar,
  });

  // Círculo con buen contraste sobre la card roja:
  // el "+" va relleno de crema (resalta) y el "−" solo con borde
  Widget _circulo(IconData icono, VoidCallback? alPulsar, {required bool relleno}) {
    return InkResponse(
      onTap: alPulsar,
      radius: 22,
      child: Container(
        width: 28,
        height: 28,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: relleno ? AppColors.goldSand : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.goldSand, width: 1.5),
        ),
        child: Icon(
          icono,
          size: 18,
          color: relleno ? AppColors.demonicPresence : AppColors.goldSand,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (cantidad > 0) ...[
          _circulo(Icons.remove, onRestar, relleno: false),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '$cantidad',
              style: const TextStyle(
                color: AppColors.goldSand,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        _circulo(Icons.add, onAgregar, relleno: true),
      ],
    );
  }
}
