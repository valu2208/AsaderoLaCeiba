import 'package:flutter/material.dart';
import 'package:asadero/core/limites_pedido.dart';

class CarritoItem {
  final String productoId;
  final String nombre;
  final String precio;
  final String imagen;
  final String? nombreEn;
  final String? nombrePt;
  final int cantidad;

  const CarritoItem({
    required this.productoId,
    required this.nombre,
    required this.precio,
    required this.imagen,
    this.nombreEn,
    this.nombrePt,
    this.cantidad = 1,
  });

  CarritoItem copiarConCantidad(int nuevaCantidad) {
    return CarritoItem(
      productoId: productoId,
      nombre: nombre,
      precio: precio,
      imagen: imagen,
      nombreEn: nombreEn,
      nombrePt: nombrePt,
      cantidad: nuevaCantidad,
    );
  }
}

class CarritoEstado {
  static final ValueNotifier<List<CarritoItem>> items =
      ValueNotifier<List<CarritoItem>>([]);

  // Mesa donde está el cliente (null = todavía no la ha indicado).
  static final ValueNotifier<int?> mesa = ValueNotifier<int?>(null);

  static int get total =>
      items.value.fold(0, (suma, item) => suma + item.cantidad);

  static int cantidadDe(String nombre) {
    for (final item in items.value) {
      if (item.nombre == nombre) return item.cantidad;
    }
    return 0;
  }

  // Devuelve null si se agregó, o la clave del mensaje si se llegó al límite.
  static String? agregar(
    String productoId,
    String nombre,
    String precio,
    String imagen, {
    String? nombreEn,
    String? nombrePt,
  }) {
    if (total >= LimitesPedido.maxPlatosPedido) return 'limite_pedido';

    final lista = List<CarritoItem>.from(items.value);
    final indice = lista.indexWhere((item) => item.productoId == productoId);

    if (indice != -1) {
      if (lista[indice].cantidad >= LimitesPedido.maxPorPlato) {
        return 'limite_plato';
      }
      lista[indice] =
          lista[indice].copiarConCantidad(lista[indice].cantidad + 1);
    } else {
      lista.add(CarritoItem(
        productoId: productoId,
        nombre: nombre,
        precio: precio,
        imagen: imagen,
        nombreEn: nombreEn,
        nombrePt: nombrePt,
      ));
    }

    items.value = lista;
    return null;
  }

  static void restar(String nombre) {
    final lista = List<CarritoItem>.from(items.value);
    final indice = lista.indexWhere((item) => item.nombre == nombre);

    if (indice == -1) return;

    if (lista[indice].cantidad > 1) {
      lista[indice] =
          lista[indice].copiarConCantidad(lista[indice].cantidad - 1);
    } else {
      lista.removeAt(indice);
    }

    items.value = lista;
  }

  static void eliminar(String nombre) {
    items.value = items.value.where((item) => item.nombre != nombre).toList();
  }

  static void vaciar() {
    items.value = [];
    mesa.value = null;
  }
}