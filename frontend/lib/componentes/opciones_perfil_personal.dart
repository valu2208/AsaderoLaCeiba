import 'package:flutter/material.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/componentes/opcion_perfil.dart';
import 'package:asadero/pantallas/notificaciones.dart';
import 'package:asadero/pantallas/pantalla_manual.dart';

// Las opciones del perfil de admin, cocinero y mesero
class OpcionesPerfilPersonal extends StatelessWidget {
  final VoidCallback onDatos;
  final VoidCallback onSalir;

  const OpcionesPerfilPersonal({
    super.key,
    required this.onDatos,
    required this.onSalir,
  });

  void _abrir(BuildContext context, Widget pantalla) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => pantalla));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          OpcionPerfil(
            icono: Icons.person_outline,
            titulo: texto('informacion_personal'),
            subtitulo: texto('consulta_datos_cuenta'),
            onTap: onDatos,
          ),
          OpcionPerfil(
            icono: Icons.notifications_none,
            titulo: texto('notificaciones'),
            subtitulo: texto('consulta_avisos'),
            onTap: () => _abrir(context, const Notificaciones()),
          ),
          OpcionPerfil(
            icono: Icons.help_outline,
            titulo: texto('ayuda'),
            subtitulo: texto('consulta_manual_usuario'),
            onTap: () => _abrir(context, const PantallaManual()),
          ),
          OpcionPerfil(
            icono: Icons.logout,
            titulo: texto('cerrar_sesion'),
            subtitulo: texto('salir_cuenta'),
            onTap: onSalir,
          ),
        ],
      ),
    );
  }
}