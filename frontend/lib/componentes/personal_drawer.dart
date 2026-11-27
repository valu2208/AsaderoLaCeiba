import 'package:flutter/material.dart';
import 'package:asadero/componentes/boton_ayuda.dart';
import 'package:asadero/componentes/encabezado_drawer.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/navegacion_rol.dart';
import 'package:asadero/pantallas/cocina_inventario.dart';
import 'package:asadero/pantallas/cocina_pedidos.dart';
import 'package:asadero/pantallas/menu_mesero.dart';
import 'package:asadero/pantallas/mesero_pedidos.dart';
import 'package:asadero/pantallas/notificaciones.dart';

// Menú lateral del personal (mesero y cocinero)
class PersonalDrawer extends StatefulWidget {
  final String rol; // 'mesero' o 'cocinero'
  final String actual; // pantalla abierta: 'pedidos', 'menu' o 'suministro'

  const PersonalDrawer({super.key, required this.rol, required this.actual});

  @override
  State<PersonalDrawer> createState() => _PersonalDrawerState();
}

class _PersonalDrawerState extends State<PersonalDrawer> {
  bool get _esCocinero => widget.rol == 'cocinero';

  // Opción del menú: si ya estás en esa pantalla solo cierra el menú
  Widget _opcion(IconData icono, String titulo, String clave, Widget pagina) {
    final seleccionada = widget.actual == clave;
    return ListTile(
      leading: Icon(icono),
      title: Text(titulo),
      selected: seleccionada,
      onTap: () {
        if (seleccionada) {
          Navigator.pop(context);
          return;
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => pagina),
        );
      },
    );
  }

  // Las opciones cambian según el rol
  List<Widget> _opcionesPorRol() {
    if (_esCocinero) {
      return [
        _opcion(Icons.receipt_long, 'Pedidos', 'pedidos', const CocinaPedidos()),
        _opcion(Icons.inventory_2_outlined, 'Suministro', 'suministro', const CocinaInventario()),
      ];
    }
    return [
      _opcion(Icons.receipt_long, 'Pedidos', 'pedidos', const MeseroPedidos()),
      _opcion(Icons.restaurant_menu, 'Menú del día', 'menu', const MenuMesero()),
    ];
  }

  void _abrirNotificaciones() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Notificaciones()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.goldSand,
      child: Column(
        children: [
          Expanded(
            child: ListTileTheme(
              iconColor: AppColors.earthBrown,
              textColor: AppColors.asphalt,
              selectedColor: AppColors.redPrayerFlag,
              selectedTileColor: AppColors.redPrayerFlag.withValues(alpha: 0.12),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  EncabezadoDrawer(
                    rol: widget.rol,
                    icono: _esCocinero ? Icons.soup_kitchen : Icons.room_service,
                  ),
                  ..._opcionesPorRol(),
                  ListTile(
                    leading: const Icon(Icons.notifications_none),
                    title: const Text('Notificaciones'),
                    onTap: _abrirNotificaciones,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app, color: Colors.red),
                    title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
                    onTap: () => cerrarSesionYSalir(context),
                  ),
                ],
              ),
            ),
          ),
          const BotonAyuda(),
        ],
      ),
    );
  }
}