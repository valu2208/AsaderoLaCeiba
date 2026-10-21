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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const Chat(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tooltip: sale al pasar el mouse (web/escritorio)
    // y al mantener presionado (celular/emulador).
    return Tooltip(
      message: 'Chat bot',
      preferBelow: false,
      waitDuration: Duration.zero,
      showDuration: const Duration(seconds: 2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.demonicPresence,
        borderRadius: BorderRadius.circular(10),
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _abrirChat(context),
          child: Image.asset(
            'assets/imagenes/chatbot.png',
            width: 64,
            height: 64,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
