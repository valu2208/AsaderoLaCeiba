import 'package:asadero/core/colores.dart';
import 'package:flutter/material.dart';

class Seleccionarnumeros extends StatefulWidget {
  final String titulo;
  const Seleccionarnumeros({super.key, required this.titulo});

  @override
  State<Seleccionarnumeros> createState() => _SeleccionarnumerosState();
}

class _SeleccionarnumerosState extends State<Seleccionarnumeros> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fondoComponentesSeleccionado,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text(widget.titulo, style: TextStyle(color: Colors.white)),
            Text("77", style: TextStyle(color:  Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(onPressed: () {}, shape: CircleBorder(), backgroundColor: AppColors.secondary, child: Icon(Icons.remove, color: Colors.white)
                ),
                SizedBox(width: 16),
                FloatingActionButton(onPressed: () {}, shape: CircleBorder(), backgroundColor: AppColors.secondary, child: Icon(Icons.add, color: Colors.white) ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
