import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/admin_user_service.dart';
import '../componentes/admin_drawer.dart';
import '../componentes/dialogo_cambio_rol.dart';
import '../componentes/filtro_roles.dart';
import '../componentes/tarjeta_usuario.dart';

class AdminUsuariosPage extends StatefulWidget {
  const AdminUsuariosPage({super.key});

  @override
  State<AdminUsuariosPage> createState() => _AdminUsuariosPageState();
}

class _AdminUsuariosPageState extends State<AdminUsuariosPage> {
  final AdminUserService _servicio = AdminUserService();
  late Future<List<UserModel>> _usuarios;
  String? _filtro; // null = mostrar todos
  String _miId = '';

  @override
  void initState() {
    super.initState();
    _usuarios = _servicio.obtenerUsuarios();
    SharedPreferences.getInstance().then((prefs) {
      if (mounted) setState(() => _miId = prefs.getString('user_id') ?? '');
    });
  }

  void _recargar() {
    setState(() {
      _usuarios = _servicio.obtenerUsuarios();
    });
  }

  void _mensaje(String texto, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto), backgroundColor: error ? Colors.red : null),
    );
  }

  Future<void> _cambiarRol(UserModel usuario, String rol) async {
    if (!await confirmarCambioRol(context, usuario, rol)) return;

    try {
      await _servicio.cambiarRol(usuario.id!, rol);
      if (!mounted) return;
      _mensaje('Rol actualizado. ${usuario.nombre} debe volver a iniciar sesión.');
      _recargar();
    } catch (e) {
      _mensaje(e.toString().replaceAll('Exception: ', ''), error: true);
    }
  }

  Widget _lista(List<UserModel> todos) {
    final usuarios = todos
        .where((u) => _filtro == null || u.rol.toLowerCase() == _filtro)
        .toList()
      ..sort((a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));

    if (usuarios.isEmpty) {
      return ListView(
        children: const [
          Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: Text('No hay usuarios con este rol')),
          ),
        ],
      );
    }

    return ListView.builder(
      itemCount: usuarios.length,
      itemBuilder: (context, index) {
        final usuario = usuarios[index];
        return TarjetaUsuario(
          usuario: usuario,
          esYo: usuario.id == _miId,
          onCambiarRol: (rol) => _cambiarRol(usuario, rol),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios y roles'),
        backgroundColor: Colors.orangeAccent,
      ),
      drawer: const AdminDrawer(actual: 'usuarios'),
      body: Column(
        children: [
          FiltroRoles(
            seleccionado: _filtro,
            onCambio: (valor) => setState(() => _filtro = valor),
          ),
          Expanded(
            child: FutureBuilder<List<UserModel>>(
              future: _usuarios,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  final error = snapshot.error.toString().replaceAll('Exception: ', '');
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(error, textAlign: TextAlign.center),
                        TextButton(onPressed: _recargar, child: const Text('Reintentar')),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    _recargar();
                    try {
                      await _usuarios;
                    } catch (_) {}
                  },
                  child: _lista(snapshot.data ?? []),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}