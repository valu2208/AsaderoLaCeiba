import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

class BarraNavegacion extends StatelessWidget {
  const BarraNavegacion({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.earthBrown,
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      selectedItemColor: AppColors.goldSand,
      unselectedItemColor: AppColors.goldSand.withValues(alpha: 0.5),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (_) {}, // aún no funcional
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menú'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
      ],
    );
  }
}
