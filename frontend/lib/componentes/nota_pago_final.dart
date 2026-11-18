import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';

class NotaPagoFinal extends StatelessWidget {
  const NotaPagoFinal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10, bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.earthBrown,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.qr_code, color: AppColors.goldSand, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              texto('pago_al_final'),
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}