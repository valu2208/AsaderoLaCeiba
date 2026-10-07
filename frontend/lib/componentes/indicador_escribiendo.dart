import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

class IndicadorEscribiendo extends StatelessWidget {
  const IndicadorEscribiendo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 6,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.goldSand,
            ),
          ),
          SizedBox(width: 8),
          Text(
            'El asistente está respondiendo...',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}