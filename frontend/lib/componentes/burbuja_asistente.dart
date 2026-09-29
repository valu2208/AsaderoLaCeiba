import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/pantallas/chat.dart';

class BurbujaAsistente extends StatelessWidget {
  const BurbujaAsistente({super.key});

  void _abrirChat(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.asphalt,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return const Chat();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _abrirChat(context),
      child: Image.asset(
        'assets/imagenes/chatbot.png',
        width: 72,
        height: 72,
        fit: BoxFit.contain,
      ),
    );
  }
}