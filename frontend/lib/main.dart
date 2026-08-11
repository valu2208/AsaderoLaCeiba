import 'package:asadero/core/colores.dart';
import 'package:asadero/pantallas/pantalla_inicio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.fondoComponentesSeleccionado,
          foregroundColor: Colors.white,
          title: Text("Calcular IMC"),
        ),
        backgroundColor: AppColors.accent,
        body: PantallaInicio(),
      ),
    );
  }
}
