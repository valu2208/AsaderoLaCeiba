import 'dart:io';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import '../services/vigilante_descargas.dart';
import 'controlador_foto.dart';
import 'recuadro_foto.dart';
import 'selector_origen_foto.dart';

// Selector de la foto del producto: Galería, Cámara, arrastrar y soltar (escritorio),
// foto arrastrada al emulador de Android, y acomodar la foto (mover y zoom)
class AdminImageSelector extends StatefulWidget {
  final ControladorFoto controlador;
  final String? imagenUrl; // foto actual del producto (modo edición)
  final bool habilitado;

  const AdminImageSelector({
    super.key,
    required this.controlador,
    this.imagenUrl,
    this.habilitado = true,
  });

  @override
  State<AdminImageSelector> createState() => _AdminImageSelectorState();
}

class _AdminImageSelectorState extends State<AdminImageSelector> {
  static const _extensionesImagen = ['jpg', 'jpeg', 'png', 'webp', 'avif'];

  bool _arrastrando = false; // true mientras hay un archivo encima del recuadro
  VigilanteDescargas? _vigilante;

  @override
  void initState() {
    super.initState();
    // Solo emulador/debug: detecta las fotos que se sueltan sobre el emulador
    if (Platform.isAndroid && kDebugMode) {
      _vigilante = VigilanteDescargas(alRecibirFoto: _fotoDelEmulador);
      _vigilante!.iniciar();
    }
  }

  @override
  void dispose() {
    _vigilante?.detener();
    super.dispose();
  }

  void _mensaje(String texto, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto), backgroundColor: color),
    );
  }

  // Foto nueva: el encuadre empieza desde cero
  void _usarImagen(File archivo) {
    widget.controlador.encuadre.value = Matrix4.identity();
    setState(() => widget.controlador.imagen = archivo);
  }

  void _fotoDelEmulador(File foto) {
    if (!mounted || !widget.habilitado) return;
    _usarImagen(foto);
    _mensaje('Foto recibida desde el escritorio', color: Colors.green);
  }

  Future<void> _elegir() async {
    final foto = await elegirFoto(context);
    if (foto != null && mounted) _usarImagen(foto);
  }

  // Archivo soltado desde el escritorio (macOS / Windows / Linux)
  void _alSoltarArchivo(DropDoneDetails detalles) {
    setState(() => _arrastrando = false);
    if (!widget.habilitado) return;

    final imagenes = detalles.files.where((f) {
      final nombre = f.name.toLowerCase();
      return _extensionesImagen.any((ext) => nombre.endsWith('.$ext'));
    });

    if (imagenes.isEmpty) {
      _mensaje('Solo se permiten imágenes (jpg, png, webp, avif)', color: Colors.red);
      return;
    }
    _usarImagen(File(imagenes.first.path));
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      enable: widget.habilitado,
      onDragEntered: (_) => setState(() => _arrastrando = true),
      onDragExited: (_) => setState(() => _arrastrando = false),
      onDragDone: _alSoltarArchivo,
      child: RecuadroFoto(
        controlador: widget.controlador,
        imagenUrl: widget.imagenUrl,
        habilitado: widget.habilitado,
        arrastrando: _arrastrando,
        onElegir: _elegir,
      ),
    );
  }
}