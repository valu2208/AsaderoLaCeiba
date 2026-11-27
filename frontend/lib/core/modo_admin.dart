import 'package:flutter/foundation.dart';

// true mientras el admin está mirando la carta como la ve el cliente.
// Con esto la barra de abajo muestra el botón "Volver al panel".
class ModoAdmin {
  static final ValueNotifier<bool> viendoCliente = ValueNotifier(false);
}