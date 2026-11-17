import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:asadero/componentes/pollo_pintor.dart';

// El pollo original del Asadero, con movimiento continuo estilo dibujos animados.
class PolloAnimado extends StatefulWidget {
  final double tamano;

  const PolloAnimado({super.key, this.tamano = 300});

  @override
  State<PolloAnimado> createState() => _PolloAnimadoState();
}

class _PolloAnimadoState extends State<PolloAnimado>
    with SingleTickerProviderStateMixin {
  late final AnimationController _reloj = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  )..repeat();

  ui.Image? _imagen;
  bool _fallo = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final datos = await rootBundle.load('assets/imagenes/logo_ceiba.jpeg');
      final codec = await ui.instantiateImageCodec(datos.buffer.asUint8List());
      final cuadro = await codec.getNextFrame();
      if (!mounted) return;
      setState(() => _imagen = cuadro.image);
    } catch (e) {
      debugPrint('No se pudo cargar el pollo: $e');
      if (mounted) setState(() => _fallo = true);
    }
  }

  @override
  void dispose() {
    _reloj.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imagen = _imagen;

    return SizedBox.square(
      dimension: widget.tamano,
      child: _fallo
          ? ClipOval(
              child: Image.asset('assets/imagenes/logo_ceiba.jpeg', fit: BoxFit.cover),
            )
          : imagen == null
          ? const SizedBox.shrink()
          : RepaintBoundary(
              child: CustomPaint(painter: PolloPintor(imagen, _reloj)),
            ),
    );
  }
}