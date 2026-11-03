// Una pestaña de pedidos: qué estados muestra y qué botón tiene cada card
class PestanaPedidos {
  final String titulo;
  final List<String> estados;
  final String vacio; // texto cuando no hay pedidos
  final String? accion; // texto del botón (null = sin botón)
  final String? estadoSiguiente; // estado al que pasa el pedido al pulsar el botón

  const PestanaPedidos({
    required this.titulo,
    required this.estados,
    required this.vacio,
    this.accion,
    this.estadoSiguiente,
  });
}