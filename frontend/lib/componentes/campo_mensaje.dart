import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

class CampoMensaje extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onEnviar;
  final bool cargando;

  const CampoMensaje({
    super.key,
    required this.controller,
    required this.onEnviar,
    required this.cargando,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF6B0000),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.goldSand.withValues(
                    alpha: 0.35,
                  ),
                ),
              ),
              child: TextField(
                controller: controller,
                enabled: !cargando,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  hintStyle: TextStyle(
                    color: AppColors.goldSand.withValues(
                      alpha: 0.7,
                    ),
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => onEnviar(),
              ),
            ),
          ),

          const SizedBox(width: 8),

          IconButton(
            onPressed: cargando ? null : onEnviar,
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFCC1100),
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
            ),
            icon: const Icon(
              Icons.send_rounded,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
