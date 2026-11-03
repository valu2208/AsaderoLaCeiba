import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import '../componentes/fondo_degradado.dart';
import '../componentes/pedidos_personal_vista.dart';
import '../componentes/pestana_pedidos.dart';
import '../componentes/personal_drawer.dart';
import 'notificaciones.dart';

// Pantalla principal del mesero: recibe los pedidos, los envía a cocina y los entrega
class MeseroPedidos extends StatelessWidget {
  const MeseroPedidos({super.key});

  static const _pestanas = [
    PestanaPedidos(
      titulo: 'Nuevos',
      estados: ['Pendiente'],
      accion: 'Enviar a cocina',
      estadoSiguiente: 'En cocina',
      vacio: 'No hay pedidos nuevos por ahora.',
    ),
    PestanaPedidos(
      titulo: 'En cocina',
      estados: ['En cocina', 'En preparación'],
      vacio: 'No hay pedidos en cocina.',
    ),
    PestanaPedidos(
      titulo: 'Listos',
      estados: ['Listo'],
      accion: 'Marcar entregado',
      estadoSiguiente: 'Entregado',
      vacio: 'No hay pedidos listos para entregar.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos', style: GoogleFonts.kronaOne(fontSize: 16)),
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
      drawer: const PersonalDrawer(rol: 'mesero', actual: 'pedidos'),
      body: const FondoDegradado(
        child: PedidosPersonalVista(
          rol: 'mesero',
          pestanas: _pestanas,
          estadoNuevo: 'Pendiente',
        ),
      ),
    );
  }
}