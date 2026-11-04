import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import '../componentes/admin_drawer.dart';
import '../componentes/fondo_degradado.dart';
import '../componentes/pedidos_personal_vista.dart';
import '../componentes/pestana_pedidos.dart';

// Control de pedidos del admin: solo mira, no cambia estados
class AdminPedidosPage extends StatelessWidget {
  const AdminPedidosPage({super.key});

  static const _pestanas = [
    PestanaPedidos(
      titulo: 'Todos',
      estados: ['Pendiente', 'En cocina', 'En preparación', 'Listo', 'Entregado'],
      vacio: 'Todavía no hay pedidos.',
    ),
    PestanaPedidos(
      titulo: 'En espera',
      estados: ['Pendiente'],
      vacio: 'No hay pedidos en espera.',
    ),
    // "Listo" va aquí: ya salió de cocina pero todavía no se entrega
    PestanaPedidos(
      titulo: 'En cocina',
      estados: ['En cocina', 'En preparación', 'Listo'],
      vacio: 'No hay pedidos en cocina.',
    ),
    PestanaPedidos(
      titulo: 'Entregados',
      estados: ['Entregado'],
      vacio: 'Todavía no hay pedidos entregados.',
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
      ),
      drawer: const AdminDrawer(actual: 'pedidos'),
      body: const FondoDegradado(
        child: PedidosPersonalVista(
          rol: 'admin',
          pestanas: _pestanas,
          estadoNuevo: 'Pendiente',
        ),
      ),
    );
  }
}