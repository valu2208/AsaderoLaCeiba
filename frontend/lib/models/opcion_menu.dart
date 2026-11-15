import 'package:flutter/material.dart';

// Una opción de la pantalla Menú (Desayuno, Almuerzo, Gaseosas, Fin de semana)
class OpcionMenu {
  final String titulo;
  final String categoria; // mismo texto que se guarda en la base de datos
  final String descripcion;
  final String imagen; // foto en assets/imagenes/
  final IconData icono; // se muestra si la foto no existe
  final Color color; // inicio del degradado
  final Color colorFin; // final del degradado
  final bool porDia; // true = el cliente solo ve los platos de hoy

  const OpcionMenu({
    required this.titulo,
    required this.categoria,
    required this.descripcion,
    required this.imagen,
    required this.icono,
    required this.color,
    required this.colorFin,
    this.porDia = false,
  });

  // Nombres de las animaciones que unen la card con la barra de arriba
  String get heroFondo => 'fondo_$categoria';
  String get heroFoto => 'foto_$categoria';

  LinearGradient get degradado => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color, colorFin],
      );
}