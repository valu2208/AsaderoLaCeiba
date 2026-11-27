import 'package:flutter/material.dart';

// Ruta con aparición suave y un poco más lenta, para que se vea la animación
// que une la card del menú con la barra de arriba de la categoría
Route<T> rutaSuave<T>(Widget pantalla) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 550),
    reverseTransitionDuration: const Duration(milliseconds: 450),
    pageBuilder: (context, animacion, otra) => pantalla,
    transitionsBuilder: (context, animacion, otra, hijo) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animacion, curve: Curves.easeOut),
        child: hijo,
      );
    },
  );
}

// Ruta sin animación: para cambiar entre las pestañas de la barra de abajo
// sin que la barra "parpadee" al moverse junto con la pantalla
Route<T> rutaInstantanea<T>(Widget pantalla) {
  return PageRouteBuilder<T>(
    opaque: true,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    pageBuilder: (context, animacion, otra) => pantalla,
  );
}