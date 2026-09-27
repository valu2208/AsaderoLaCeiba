import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

class EncabezadoChat extends StatelessWidget {
  const EncabezadoChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),

        Container(
          width: 42,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.goldSand,
            borderRadius: BorderRadius.circular(3),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.goldSand,
                child: Icon(
                  Icons.support_agent,
                  color: AppColors.redPrayerFlag,
                  size: 26,
                ),
              ),

              const SizedBox(width: 12),

              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Asistente IA',
                    style: TextStyle(
                      color: AppColors.goldSand,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  SizedBox(height: 2),

                  Text(
                    'En línea - Respuestas al instante',
                    style: TextStyle(
                      color: Color(0xFF8FD694),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const Divider(
          height: 1,
          thickness: 1,
          color: AppColors.earthBrown,
        ),
      ],
    );
  }
}