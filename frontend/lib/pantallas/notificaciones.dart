import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/componentes/dialogo_borrar_leidas.dart';
import 'package:asadero/componentes/dialogo_notificacion.dart';
import 'package:asadero/componentes/fondo_degradado.dart';
import 'package:asadero/componentes/lista_notificaciones.dart';
import 'package:asadero/services/notificaciones_service.dart';

class Notificaciones extends StatefulWidget {
  const Notificaciones({super.key});

  @override
  State<Notificaciones> createState() => _NotificacionesState();
}

class _NotificacionesState extends State<Notificaciones> {
  List<Map<String, dynamic>> notificaciones = [];
  bool cargando = true;
  bool eliminando = false;
  String? error;

  bool get _hayLeidas => notificaciones.any((n) => n['leida'] == true);

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  String _clave(Object e) => e.toString().replaceFirst('Exception: ', '');

  void _aviso(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _cargar() async {
    setState(() {
      cargando = true;
      error = null;
    });

    try {
      final datos = await NotificacionesService.listar();
      if (!mounted) return;
      setState(() {
        notificaciones = datos;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = texto(_clave(e));
        cargando = false;
      });
    }
  }

  // Abre la ventana de detalle y la marca como leída
  Future<void> _abrir(Map<String, dynamic> notificacion) async {
    showDialog(
      context: context,
      builder: (_) => DialogoNotificacion(notificacion: notificacion),
    );

    if (notificacion['leida'] == true) return;

    try {
      await NotificacionesService.marcarLeida('${notificacion['id']}');
      if (!mounted) return;
      setState(() => notificacion['leida'] = true);
    } catch (e) {
      if (mounted) _aviso(texto(_clave(e)));
    }
  }

  Future<void> _borrarLeidas() async {
    if (!await confirmarBorrarLeidas(context)) return;

    setState(() => eliminando = true);

    try {
      await NotificacionesService.eliminarLeidas();
      if (!mounted) return;
      setState(() {
        notificaciones.removeWhere((n) => n['leida'] == true);
        eliminando = false;
      });
      _aviso(texto('notificaciones_eliminadas'));
    } catch (e) {
      if (!mounted) return;
      setState(() => eliminando = false);
      _aviso(texto(_clave(e)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Idioma.seleccionado,
      builder: (context, idioma, child) {
        return Scaffold(
          backgroundColor: AppColors.goldSand,
          appBar: AppBar(
            backgroundColor: AppColors.asphalt,
            foregroundColor: AppColors.goldSand,
            centerTitle: true,
            title: Text(texto('notificaciones'), style: GoogleFonts.kronaOne(fontSize: 16)),
            actions: [
              IconButton(
                onPressed: cargando ? null : _cargar,
                icon: const Icon(Icons.refresh),
                tooltip: texto('actualizar'),
              ),
              if (_hayLeidas)
                IconButton(
                  onPressed: eliminando || cargando ? null : _borrarLeidas,
                  icon: eliminando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.goldSand),
                        )
                      : const Icon(Icons.delete_outline),
                  tooltip: texto('borrar_leidas'),
                ),
            ],
          ),
          body: FondoDegradado(
            child: RefreshIndicator(
              onRefresh: _cargar,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    texto('tus_avisos'),
                    style: GoogleFonts.kronaOne(fontSize: 17, color: AppColors.earthBrown),
                  ),
                  const SizedBox(height: 16),
                  ListaNotificaciones(
                    cargando: cargando,
                    error: error,
                    notificaciones: notificaciones,
                    onReintentar: _cargar,
                    onAbrir: _abrir,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}