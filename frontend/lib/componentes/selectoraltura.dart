import 'package:asadero/core/colores.dart';
import 'package:flutter/material.dart';

class Selectoraltura extends StatefulWidget {
  const Selectoraltura({super.key});

  @override
  State<Selectoraltura> createState() => _SelectoralturaState();
}

class _SelectoralturaState extends State<Selectoraltura> {
  double altura = 170; //altura inicial

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only (left: 16, right: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.fondoComponentesSeleccionado,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            //titulo 
            Text("ALTURA", style: TextStyle(color: Colors.white)),
            Text("${altura.toStringAsFixed(0)} Cm", style: TextStyle(color: Colors.white, fontSize:  34, fontWeight: FontWeight.bold
            ),
            ),
            Slider(value: altura, onChanged: (nuevaAltura){
              setState(() {
                altura = nuevaAltura;
              });
            },
            min: 150,
            max: 220,
            divisions: 70,
            activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}