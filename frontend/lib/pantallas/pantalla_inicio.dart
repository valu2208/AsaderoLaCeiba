import 'package:asadero/componentes/seleccionarnumeros.dart';
import 'package:asadero/componentes/selectoraltura.dart';
import 'package:asadero/componentes/selectorgenero.dart';
import 'package:asadero/core/colores.dart';
import 'package:flutter/material.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Selectorgenero(),
        Selectoraltura(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(child: Seleccionarnumeros(titulo: "EDAD")),
              SizedBox(width: 16),
              Expanded(child: Seleccionarnumeros(titulo: "PESO")),
            ],
          ),
        ),
        Spacer(), //bajar el boton, dejarlo al final
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 60,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(8),
                  ),
                ),
                backgroundColor: WidgetStatePropertyAll(
                  AppColors.fondoComponentesSeleccionado,
                ),
              ),
              child: Text(
                "Calcular",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
