// Error al hablar con el servidor, con el código HTTP para saber qué pasó.
// codigo == null significa que no hubo respuesta (sin internet o servidor caído).
class ErrorApi implements Exception {
  final int? codigo;
  final String mensaje;

  const ErrorApi(this.codigo, this.mensaje);

  // 502/503/504 o respuesta que no es JSON: Render (plan Free) despertando.
  bool get servidorNoDisponible =>
      codigo == null || codigo == 502 || codigo == 503 || codigo == 504;

  @override
  String toString() => mensaje;
}