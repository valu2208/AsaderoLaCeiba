// Muestra un valor en pesos con puntos de miles: 25000.0 -> $25.000
String formatoPesos(double valor) {
  final entero = valor.round().toString();
  final conPuntos = entero.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );
  return '\$$conPuntos';
}
