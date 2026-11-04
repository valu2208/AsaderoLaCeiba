import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/navegacion_rol.dart';
import 'package:asadero/pantallas/admin_inventario_page.dart';
import 'package:asadero/pantallas/admin_menu_page.dart';
import 'package:asadero/pantallas/admin_pedidos_page.dart';
import 'package:asadero/pantallas/admin_product_list_page.dart';
import 'package:asadero/pantallas/admin_usuarios_page.dart';
import 'package:asadero/pantallas/home.dart';

class AdminDrawer extends StatefulWidget {
  // pantalla abierta: 'productos', 'menu', 'inventario', 'pedidos' o 'usuarios'
  final String actual;

  const AdminDrawer({super.key, this.actual = 'productos'});

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  String _nombre = 'Administrador';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  // Lee los datos guardados al iniciar sesión
  Future<void> _cargarDatosUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _nombre = prefs.getString('user_nombre') ?? 'Administrador';
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

  // Muestra la carta tal como la ve el cliente (con "atrás" se vuelve al panel)
  void _verCartaCliente() {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const Home()));
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
            accountEmail: Text(_email),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: AppColors.goldSand,
              child: Icon(
                Icons.admin_panel_settings,
                size: 40,
                color: AppColors.redPrayerFlag,
              ),
            ),
            decoration: const BoxDecoration(color: AppColors.earthBrown),
          ),
          _opcion(Icons.fastfood, 'Gestionar Productos', 'productos',
              const AdminProductListPage()),
          _opcion(Icons.restaurant_menu, 'Menú', 'menu', const AdminMenuPage()),
          _opcion(Icons.inventory_2, 'Inventario', 'inventario',
              const AdminInventarioPage()),
          _opcion(Icons.receipt_long, 'Pedidos', 'pedidos',
              const AdminPedidosPage()),
          _opcion(Icons.people, 'Usuarios y roles', 'usuarios',
              const AdminUsuariosPage()),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text('Ver carta (cliente)'),
            onTap: _verCartaCliente,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () => cerrarSesionYSalir(context),
          ),
          ],
        ),
      ),
    );
  }
}