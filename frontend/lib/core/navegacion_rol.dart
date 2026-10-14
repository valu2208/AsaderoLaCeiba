import 'package:flutter/material.dart';
import 'package:asadero/services/user_service.dart';
import 'package:asadero/pantallas/home.dart';
import 'package:asadero/pantallas/login.dart';
import 'package:asadero/pantallas/admin_product_list_page.dart';
import 'package:asadero/pantallas/panel_pendiente.dart';

// Devuelve la pantalla de inicio que le corresponde a cada rol
Widget pantallaPorRol(String rol) {
  switch (rol.toLowerCase()) {
    case 'admin':
      return const AdminProductListPage();
    case 'mesero':
      return const PanelPendiente(titulo: 'Panel del mesero');
    case 'cocinero':
      return const PanelPendiente(titulo: 'Panel de cocina');
    default:
      return const Home(); // 'usuario' (cliente)
  }
}

// Lleva al usuario a su pantalla y borra el historial (no puede volver al login con "atrás")
void irSegunRol(BuildContext context, String rol) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => pantallaPorRol(rol)),
    (route) => false,
  );
}

// Borra la sesión guardada y vuelve al login sin historial
Future<void> cerrarSesionYSalir(BuildContext context) async {
  await UserService.cerrarSesion();
  if (!context.mounted) return;
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => const Login()),
    (route) => false,
  );
}