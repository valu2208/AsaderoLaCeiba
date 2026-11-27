import 'package:flutter/services.dart';

// Deja solo los números de un texto: "25.000" -> "25000"
String soloDigitos(String texto) => texto.replaceAll(RegExp(r'[^0-9]'), '');

String _conPuntos(String digitos) {
  return digitos.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.');
}

// Pone los puntos de miles: 25000 -> "25.000"
String formatoMiles(num valor) => _conPuntos(valor.round().toString());

// Mientras se escribe el precio, agrega solos los puntos de miles
class FormatoMiles extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue anterior,
    TextEditingValue nuevo,
  ) {
    var digitos = soloDigitos(nuevo.text).replaceFirst(RegExp(r'^0+'), '');
    if (digitos.length > 9) digitos = digitos.substring(0, 9);

    final texto = _conPuntos(digitos);
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}