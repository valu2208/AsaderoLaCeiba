import 'package:flutter/material.dart';

// Roles que existen en el sistema (así se guardan en la base de datos)
const List<String> rolesSistema = ['usuario', 'mesero', 'cocinero', 'admin'];

// Nombre para mostrar en pantalla
String nombreRol(String rol) {
  switch (rol.toLowerCase()) {
    case 'admin':
      return 'Administrador';
    case 'mesero':
      return 'Mesero';
    case 'cocinero':
      return 'Cocinero';
    default:
      return 'Cliente';
  }
}

// Color de cada rol (avatar y etiqueta)
Color colorRol(String rol) {
  switch (rol.toLowerCase()) {
    case 'admin':
      return Colors.red;
    case 'mesero':
      return Colors.blue;
    case 'cocinero':
      return Colors.green;
    default:
      return Colors.grey;
  }
}
