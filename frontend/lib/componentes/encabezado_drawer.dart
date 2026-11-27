import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/roles.dart';
import 'package:asadero/componentes/avatar_usuario.dart';
import 'package:asadero/pantallas/perfil_personal.dart';
import 'package:asadero/services/user_service.dart';

// Parte de arriba del menú lateral de admin, cocina y mesero: foto, nombre y
// correo. Al tocarla se abre el perfil (donde se puede cambiar la foto).
class EncabezadoDrawer extends StatefulWidget {
  final String rol; // 'admin', 'mesero' o 'cocinero'
  final IconData icono; // se muestra mientras la persona no tenga foto

  const EncabezadoDrawer({super.key, required this.rol, required this.icono});

  @override
  State<EncabezadoDrawer> createState() => _EncabezadoDrawerState();
}

class _EncabezadoDrawerState extends State<EncabezadoDrawer> {
  String _nombre = '';
  String _email = '';
  String? _avatar;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final nombre = await UserService.getNombre();
    final avatar = await UserService.getAvatar();

    if (!mounted) return;

    setState(() {
      _nombre = nombre.isEmpty ? nombreRol(widget.rol) : nombre;
      _email = prefs.getString('user_email') ?? '';
      _avatar = avatar;
    });
  }

  // Cierra el menú y abre el perfil
  void _abrirPerfil() {
    final navegador = Navigator.of(context);
    navegador.pop();
    navegador.push(MaterialPageRoute(builder: (_) => const PerfilPersonal()));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _abrirPerfil,
      child: UserAccountsDrawerHeader(
        accountName: Text(
          _nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        accountEmail: Text(_email.isEmpty ? nombreRol(widget.rol) : _email),
        currentAccountPicture: AvatarUsuario(url: _avatar, icono: widget.icono),
        decoration: const BoxDecoration(color: AppColors.earthBrown),
      ),
    );
  }
}