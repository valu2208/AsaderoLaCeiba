
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Idioma {
  static const String _claveIdioma = 'idioma_seleccionado';

  static const List<String> idiomasDisponibles = [
    'Español',
    'English',
    'Português',
  ];

  static final ValueNotifier<String> seleccionado =
      ValueNotifier<String>('Español');

  // Recuperar el idioma guardado al abrir la aplicación.
  static Future<void> cargar() async {
    final preferencias = await SharedPreferences.getInstance();

    final idiomaGuardado = preferencias.getString(_claveIdioma);

    if (idiomaGuardado != null &&
        idiomasDisponibles.contains(idiomaGuardado)) {
      seleccionado.value = idiomaGuardado;
    }
  }

  // Cambiar y guardar el idioma seleccionado.
  static Future<void> cambiar(String idioma) async {
    if (!idiomasDisponibles.contains(idioma)) {
      return;
    }

    seleccionado.value = idioma;

    final preferencias = await SharedPreferences.getInstance();

    await preferencias.setString(_claveIdioma, idioma);
  }

  // Consultar el idioma actual.
  static String get actual => seleccionado.value;
}
