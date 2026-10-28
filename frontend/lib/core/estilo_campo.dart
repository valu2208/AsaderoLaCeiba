import 'package:flutter/material.dart';

// Decoración de los campos de texto de los formularios del admin
InputDecoration decoracionCampo(String etiqueta) {
  return InputDecoration(
    labelText: etiqueta,
    filled: true,
    fillColor: Colors.white.withValues(alpha: 0.6),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  );
}