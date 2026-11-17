import 'package:flutter/material.dart';

// Hace que su hijo palpite (crezca y se encoja) de forma continua.
class Pulsante extends StatefulWidget {
  final Widget hijo;

  const Pulsante({super.key, required this.hijo});

  @override
  State<Pulsante> createState() => _PulsanteState();
}

class _PulsanteState extends State<Pulsante>
    with SingleTickerProviderStateMixin {
  late final AnimationController _control = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..repeat(reverse: true);

  late final Animation<double> _escala = Tween<double>(begin: 1.0, end: 1.15)
      .animate(CurvedAnimation(parent: _control, curve: Curves.easeInOut));

  @override
  void dispose() {
    _control.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _escala, child: widget.hijo);
  }
}