import 'package:asadero/core/colores.dart';
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
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectorGenero = "Hombre";
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 16,
                left: 16,
                right: 8,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: selectorGenero == "Hombre"
                      ? AppColors.secondary
                      : AppColors.fondoComponentesSeleccionado,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Image.asset("assets/imagenes/male.png", height: 100),
                      Text(
                        "Hombre".toUpperCase(),
                        style: Estilotexto.estilosLetra,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        //mujer
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectorGenero = "Mujer";
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 16,
                left: 8,
                right: 16,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: selectorGenero == "Mujer"
                      ? AppColors.secondary
                      : AppColors.fondoComponentesSeleccionado,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Image.asset("assets/imagenes/female.png", height: 100),
                      Text(
                        "Mujer".toUpperCase(),
                        style: Estilotexto.estilosLetra,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
