import 'package:asadero/core/estilotexto.dart';
import 'package:flutter/material.dart';

class Selectorgenero extends StatefulWidget {
  const Selectorgenero({super.key});

  @override
  State<Selectorgenero> createState() => _SelectorgeneroState();
}

class _SelectorgeneroState extends State<Selectorgenero> {
  String? selectorGenero;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //hombre
        Column(
          children: [
          Image.asset("assets/imagenes/male.png", height: 100),
          Text ("Hombre".toUpperCase(), style: Estilotexto.estilosLetra),
      ],
      ),
        //mujer
        Column(
          children: [
            Image.asset("assets/imagenes/female.png", height: 100),
          Text ("Mujer".toUpperCase(), 
            style: Estilotexto.estilosLetra),
          ],
        ),
      ],
    );
  }  
}
