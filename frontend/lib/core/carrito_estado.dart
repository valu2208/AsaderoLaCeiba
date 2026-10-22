import 'package:flutter/material.dart';

class CarritoItem {
  final String nombre;
  final String precio;
  final String imagen;
  final int cantidad;

  const CarritoItem({
    required this.nombre,
    required this.precio,
    required this.imagen,
    this.cantidad = 1,
  });

  CarritoItem copiarConCantidad(int nuevaCantidad) {
    return CarritoItem(
      nombre: nombre,
      precio: precio,
      imagen: imagen,
      cantidad: nuevaCantidad,
    );
  }
}

class CarritoEstado {
  static final ValueNotifier<List<CarritoItem>> items =
      ValueNotifier<List<CarritoItem>>([]);

  static int get total =>
      items.value.fold(0, (suma, item) => suma + item.cantidad);

  static int cantidadDe(String nombre) {
    for (final item in items.value) {
      if (item.nombre == nombre) {
        return item.cantidad;
      }
    }
    return 0;
  }

  static void agregar(String nombre, String precio, String imagen) {
    final lista = List<CarritoItem>.from(items.value);
    final indice = lista.indexWhere((item) => item.nombre == nombre);

    if (indice != -1) {
      lista[indice] = lista[indice].copiarConCantidad(
        lista[indice].cantidad + 1,
      );
    } else {
      lista.add(CarritoItem(nombre: nombre, precio: precio, imagen: imagen));
    }

    items.value = lista;
  }

  static void restar(String nombre) {
    final lista = List<CarritoItem>.from(items.value);
    final indice = lista.indexWhere((item) => item.nombre == nombre);

    if (indice == -1) return;

    if (lista[indice].cantidad > 1) {
      lista[indice] = lista[indice].copiarConCantidad(
        lista[indice].cantidad - 1,
      );
    } else {
      lista.removeAt(indice);
    }

    items.value = lista;
  }

  static void eliminar(String nombre) {
    items.value = items.value.where((item) => item.nombre != nombre).toList();
  }
}

