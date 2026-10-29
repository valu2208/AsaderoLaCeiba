import 'package:asadero/pantallas/notificaciones.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/navegacion_rol.dart';
import 'package:asadero/services/user_service.dart';
import 'package:asadero/componentes/barra_nav_inferior.dart';
import 'package:asadero/pantallas/home.dart';
import 'package:asadero/pantallas/historial.dart';
import 'package:asadero/pantallas/carrito.dart';
import 'package:asadero/pantallas/informacion_personal.dart';
import 'package:asadero/pantallas/productos.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  String nombre = '';
  String correo = '';
  String? avatar;
  bool cargando = true;
  bool eliminandoCuenta = false;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  void _abrirNotificaciones() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Notificaciones()),
    );
  }

  Future<void> _cargarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final nombreUsuario = await UserService.getNombre();
    final fotoUsuario = await UserService.getAvatar();

    if (!mounted) return;

    setState(() {
      nombre = nombreUsuario;
      correo = prefs.getString('user_email') ?? '';
      avatar = (fotoUsuario != null && fotoUsuario.isNotEmpty)
          ? fotoUsuario
          : null;
      cargando = false;
    });
  }

  // Barra inferior: 0 Home, 1 Perfil (esta pantalla), 2 Menú, 3 Historial, 4 Carrito
  void _navegar(int indice) {
    if (indice == 1) return;

    final Widget pantalla;
    if (indice == 0) {
      pantalla = const Home();
    } else if (indice == 2) {
      pantalla = const Productos();
    } else if (indice == 3) {
      pantalla = const Historial();
    } else {
      pantalla = const Carrito();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => pantalla),
    );
  }

  Future<void> _abrirInformacionPersonal() async {
    final actualizado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const InformacionPersonal()),
    );

    if (actualizado == true) {
      await _cargarUsuario();
    }
  }

  Future<void> _confirmarEliminarCuenta() async {
    final confirmar = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.asphalt,
        title: const Text(
          'Eliminar cuenta',
          style: TextStyle(
            color: AppColors.goldSand,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          '¿Estás seguro de que deseas eliminar tu cuenta permanentemente? '
          'Esta acción no se puede deshacer y podrías perder tus pedidos '
          'y otros datos asociados.',
          style: TextStyle(color: AppColors.goldSand),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.goldSand),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Eliminar definitivamente',
              style: TextStyle(color: AppColors.redPrayerFlag),
            ),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    setState(() {
      eliminandoCuenta = true;
    });

    try {
      await UserService.eliminarCuenta();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tu cuenta se eliminó correctamente.'),
          backgroundColor: AppColors.earthBrown,
        ),
      );

      await cerrarSesionYSalir(context);
    } catch (e) {
      if (!mounted) return;

      _mensaje(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          eliminandoCuenta = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.asphalt,
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.goldSand, AppColors.redPrayerFlag],
          ),
        ),
        child: Column(
          children: [
            Container(
              color: AppColors.asphalt,
              height: MediaQuery.of(context).padding.top,
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                      decoration: const BoxDecoration(
                        color: AppColors.asphalt,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.goldSand,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Mi perfil',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.kronaOne(
                                    color: AppColors.goldSand,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 48),
                            ],
                          ),
                          const SizedBox(height: 20),
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: AppColors.earthBrown,
                            child: ClipOval(
                              child: avatar != null
                                  ? Image.network(
                                      avatar!,
                                      width: 96,
                                      height: 96,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _iconoPerfil(),
                                    )
                                  : _iconoPerfil(),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            cargando
                                ? 'Cargando...'
                                : nombre.isEmpty
                                ? 'Usuario'
                                : nombre,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.kronaOne(
                              color: AppColors.goldSand,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            correo,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.goldSand,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          _opcion(
                            icono: Icons.person_outline,
                            titulo: 'Información personal',
                            subtitulo: 'Consulta los datos de tu cuenta',
                            onTap: _abrirInformacionPersonal,
                          ),
                          _opcion(
                            icono: Icons.notifications_none,
                            titulo: 'Notificaciones',
                            subtitulo: 'Consulta tus avisos',
                            onTap: _abrirNotificaciones,
                          ),
                          _opcion(
                            icono: Icons.logout,
                            titulo: 'Cerrar sesión',
                            subtitulo: 'Salir de tu cuenta',
                            onTap: _confirmarSalida,
                          ),
                          const SizedBox(height: 20),
                          _opcion(
                            icono: Icons.delete_outline,
                            titulo: 'Eliminar cuenta',
                            subtitulo: 'Borra permanentemente tu cuenta',
                            onTap: eliminandoCuenta
                                ? () {}
                                : _confirmarEliminarCuenta,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BarraNavegacionInferior(
        indiceActual: 1,
        onTap: _navegar,
      ),
    );
  }

  Widget _iconoPerfil() {
    return const SizedBox(
      width: 96,
      height: 96,
      child: Icon(Icons.person, color: AppColors.goldSand, size: 48),
    );
  }

  Widget _opcion({
    required IconData icono,
    required String titulo,
    required String subtitulo,
    required VoidCallback onTap,
  }) {
    return Card(
      color: AppColors.earthBrown,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icono, color: AppColors.goldSand, size: 28),
        title: Text(
          titulo,
          style: const TextStyle(
            color: AppColors.goldSand,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitulo,
          style: TextStyle(
            color: AppColors.goldSand.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
        trailing: eliminandoCuenta && titulo == 'Eliminar cuenta'
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.goldSand,
                ),
              )
            : const Icon(Icons.chevron_right, color: AppColors.goldSand),
        onTap: onTap,
      ),
    );
  }

  void _mensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto), backgroundColor: AppColors.earthBrown),
    );
  }

  Future<void> _confirmarSalida() async {
    final salir = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.asphalt,
        title: const Text(
          'Cerrar sesión',
          style: TextStyle(color: AppColors.goldSand),
        ),
        content: const Text(
          '¿Seguro que deseas salir de tu cuenta?',
          style: TextStyle(color: AppColors.goldSand),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.goldSand),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Salir',
              style: TextStyle(color: AppColors.redPrayerFlag),
            ),
          ),
        ],
      ),
    );

    if (salir == true && mounted) {
      await cerrarSesionYSalir(context);
    }
  }
}