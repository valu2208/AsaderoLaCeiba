import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/core/navegacion_rol.dart';
import 'package:asadero/core/roles.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/componentes/cabecera_perfil_personal.dart';
import 'package:asadero/componentes/dialogo_cerrar_sesion.dart';
import 'package:asadero/componentes/fondo_degradado.dart';
import 'package:asadero/componentes/opciones_perfil_personal.dart';
import 'package:asadero/pantallas/informacion_personal.dart';
import 'package:asadero/services/user_service.dart';

// Perfil de admin, cocinero y mesero: cambiar la foto, ver sus datos,
// notificaciones, ayuda y cerrar sesión
class PerfilPersonal extends StatefulWidget {
  const PerfilPersonal({super.key});

  @override
  State<PerfilPersonal> createState() => _PerfilPersonalState();
}

class _PerfilPersonalState extends State<PerfilPersonal> {
  String nombre = '';
  String correo = '';
  String rol = '';
  String? avatar;
  bool subiendoFoto = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final nombreGuardado = await UserService.getNombre();
    final rolGuardado = await UserService.getRol();
    final foto = await UserService.getAvatar();

    if (!mounted) return;

    setState(() {
      rol = rolGuardado;
      nombre = nombreGuardado.isEmpty ? nombreRol(rolGuardado) : nombreGuardado;
      correo = prefs.getString('user_email') ?? '';
      avatar = (foto != null && foto.isNotEmpty) ? foto : null;
    });
  }

  void _mensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: AppColors.earthBrown),
    );
  }

  Future<void> _cambiarFoto() async {
    if (subiendoFoto) return;

    try {
      final imagen = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (imagen == null || !mounted) return;

      setState(() => subiendoFoto = true);
      final nuevaFoto = await UserService.actualizarAvatar(imagen);

      if (!mounted) return;
      setState(() => avatar = nuevaFoto);
      _mensaje(texto('foto_actualizada'));
    } catch (_) {
      if (mounted) _mensaje(texto('error_actualizar_foto'));
    } finally {
      if (mounted) setState(() => subiendoFoto = false);
    }
  }

  Future<void> _abrirDatos() async {
    final actualizado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const InformacionPersonal()),
    );

    if (actualizado == true) await _cargar();
  }

  Future<void> _salir() async {
    if (await confirmarCerrarSesion(context) && mounted) {
      await cerrarSesionYSalir(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Idioma.seleccionado,
      builder: (context, idioma, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(texto('mi_perfil')),
            centerTitle: true,
            backgroundColor: AppColors.asphalt,
            foregroundColor: AppColors.goldSand,
          ),
          body: FondoDegradado(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                CabeceraPerfilPersonal(
                  nombre: nombre,
                  correo: correo,
                  rol: nombreRol(rol),
                  avatar: avatar,
                  subiendoFoto: subiendoFoto,
                  onCambiarFoto: _cambiarFoto,
                ),
                OpcionesPerfilPersonal(
                  onDatos: _abrirDatos,
                  onSalir: _salir,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}