import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import '../componentes/fondo_degradado.dart';
import '../componentes/pedidos_personal_vista.dart';
import '../componentes/personal_drawer.dart';
import '../componentes/pestana_pedidos.dart';
import 'notificaciones.dart';

// Pantalla principal de cocina: los pedidos que el mesero envió
class CocinaPedidos extends StatelessWidget {
  const CocinaPedidos({super.key});

  static const _pestanas = [
    PestanaPedidos(
      titulo: 'Por preparar',
      estados: ['En cocina'],
      accion: 'Empezar a preparar',
      estadoSiguiente: 'En preparación',
      vacio: 'No hay pedidos por preparar.',
    ),
    PestanaPedidos(
      titulo: 'Preparando',
      estados: ['En preparación'],
      accion: 'Marcar listo',
      estadoSiguiente: 'Listo',
      vacio: 'No estás preparando ningún pedido.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cocina', style: GoogleFonts.kronaOne(fontSize: 16)),
        centerTitle: true,
        backgroundColor: AppColors.earthBrown,
        foregroundColor: AppColors.goldSand,
        actions: [
          IconButton(
            tooltip: 'Notificaciones',
            icon: const Icon(Icons.notifications_none),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Notificaciones()),
            ),
          ),
        ],
      ),
      drawer: const PersonalDrawer(rol: 'cocinero', actual: 'pedidos'),
      body: const FondoDegradado(
        child: PedidosPersonalVista(
          rol: 'cocina',
          pestanas: _pestanas,
          estadoNuevo: 'En cocina',
        ),
      ),
    );
  }
}