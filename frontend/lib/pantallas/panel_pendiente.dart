import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/navegacion_rol.dart';

// Pantalla temporal para los roles que aún no tienen su panel (mesero, cocinero)
class PanelPendiente extends StatelessWidget {
  final String titulo;

  const PanelPendiente({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldSand,
      appBar: AppBar(
        title: Text(titulo, style: const TextStyle(color: AppColors.goldSand)),
        backgroundColor: AppColors.earthBrown,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout, color: AppColors.goldSand),
            onPressed: () => cerrarSesionYSalir(context),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Esta pantalla se construye en el paso 4',
          style: TextStyle(color: AppColors.asphalt, fontSize: 16),
        ),
      ),
    );
  }
}