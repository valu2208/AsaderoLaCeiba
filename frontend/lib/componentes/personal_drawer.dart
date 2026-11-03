import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/navegacion_rol.dart';
import 'package:asadero/core/roles.dart';
import 'package:asadero/pantallas/menu_mesero.dart';
import 'package:asadero/pantallas/mesero_pedidos.dart';
import 'package:asadero/pantallas/notificaciones.dart';

// Menú lateral del personal (mesero y, más adelante, cocinero)
class PersonalDrawer extends StatefulWidget {
  final String rol; // 'mesero' o 'cocinero'
  final String actual; // pantalla abierta: 'pedidos' o 'menu'

  const PersonalDrawer({super.key, required this.rol, required this.actual});

  @override
  State<PersonalDrawer> createState() => _PersonalDrawerState();
}

class _PersonalDrawerState extends State<PersonalDrawer> {
  String _nombre = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  Future<void> _cargarDatosUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _nombre = prefs.getString('user_nombre') ?? nombreRol(widget.rol);
      _email = prefs.getString('user_email') ?? '';
    });
  }

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
      child: ListTileTheme(
        iconColor: AppColors.earthBrown,
        textColor: AppColors.asphalt,
        selectedColor: AppColors.redPrayerFlag,
        selectedTileColor: AppColors.redPrayerFlag.withValues(alpha: 0.12),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                _nombre,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(_email.isEmpty ? nombreRol(widget.rol) : _email),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: AppColors.goldSand,
                child: Icon(Icons.room_service, size: 36, color: AppColors.redPrayerFlag),
              ),
              decoration: const BoxDecoration(color: AppColors.earthBrown),
            ),
            _opcion(Icons.receipt_long, 'Pedidos', 'pedidos', const MeseroPedidos()),
            _opcion(Icons.restaurant_menu, 'Menú del día', 'menu', const MenuMesero()),
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
    );
  }
}