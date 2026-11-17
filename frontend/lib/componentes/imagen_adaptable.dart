import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/contenido_imagen.dart';
import 'package:asadero/componentes/foto_pintor.dart';

// Muestra una foto (URL de Cloudinary o asset) llenando TODO su espacio.
// Antes de dibujarla quita los márgenes blancos que traiga la foto, así la comida
// ocupa el cuadro y se recorta lo mínimo. Si la foto falla o no hay, muestra un ícono.
class ImagenAdaptable extends StatefulWidget {
  final String ruta;
  final double? ancho;
  final double? alto;

  const ImagenAdaptable({super.key, required this.ruta, this.ancho, this.alto});

  @override
  State<ImagenAdaptable> createState() => _ImagenAdaptableState();
}

class _ImagenAdaptableState extends State<ImagenAdaptable> {
  static final Map<String, Rect> _contenidos = {};

  late final ImageStreamListener _oyente = ImageStreamListener(
    _alCargar,
    onError: (error, stack) {
      if (mounted) setState(() => _fallo = true);
    },
  );

  ImageStream? _flujo;
  ui.Image? _imagen;
  Rect? _contenido;
  bool _fallo = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void didUpdateWidget(ImagenAdaptable anterior) {
    super.didUpdateWidget(anterior);
    if (anterior.ruta != widget.ruta) _cargar();
  }

  void _cargar() {
    _flujo?.removeListener(_oyente);
    _imagen?.dispose();
    _imagen = null;
    _contenido = null;
    _fallo = false;

    if (widget.ruta.isEmpty) return;

    final ImageProvider proveedor = widget.ruta.startsWith('http')
        ? NetworkImage(widget.ruta)
        : AssetImage(widget.ruta);

    _flujo = proveedor.resolve(ImageConfiguration.empty)..addListener(_oyente);
  }

  Future<void> _alCargar(ImageInfo info, bool sincrona) async {
    final ruta = widget.ruta;
    final copia = info.image.clone();

    var contenido = _contenidos[ruta];
    if (contenido == null) {
      contenido = await detectarContenido(copia);
      _contenidos[ruta] = contenido;
      debugPrint('Foto ${copia.width}x${copia.height}, parte útil: $contenido');
    }

    if (!mounted || ruta != widget.ruta) {
      copia.dispose();
      return;
    }

    _imagen?.dispose();
    setState(() {
      _imagen = copia;
      _contenido = contenido;
    });
  }

  @override
  void dispose() {
    _flujo?.removeListener(_oyente);
    _imagen?.dispose();
    super.dispose();
  }

  Widget _reemplazo({bool cargando = false}) {
    return Container(
      color: AppColors.earthBrown,
      alignment: Alignment.center,
      child: cargando
          ? const CircularProgressIndicator(color: AppColors.goldSand)
          : const Icon(Icons.restaurant, color: AppColors.goldSand, size: 40),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagen = _imagen;
    final contenido = _contenido;

    final Widget hijo;
    if (widget.ruta.isEmpty || _fallo) {
      hijo = _reemplazo();
    } else if (imagen == null || contenido == null) {
      hijo = _reemplazo(cargando: true);
    } else {
      hijo = CustomPaint(painter: FotoPintor(imagen, contenido));
    }

    return SizedBox(width: widget.ancho, height: widget.alto, child: hijo);
  }
}