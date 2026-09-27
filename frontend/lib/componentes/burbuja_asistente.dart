import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/pantallas/chat.dart';

class BurbujaAsistente extends StatelessWidget {
  const BurbujaAsistente({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.redPrayerFlag,
      onPressed: () {
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
            return const SizedBox(
              height: 600,
              child: Chat(),
            );
          },
        );
      },
      child: ClipOval(
        child: Image.asset(
          'assets/imagenes/Chat_bot.jpeg',
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
