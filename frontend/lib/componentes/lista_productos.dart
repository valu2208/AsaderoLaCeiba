import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/componentes/fila_producto.dart';
import 'package:asadero/componentes/tarjeta_producto.dart';
import 'package:asadero/pantallas/detalle_producto.dart';

class ListaProductos extends StatelessWidget {
  final List<Map<String, String>> productos;
  final int columnas; // 2 = cuadrícula como en el Home, 1 = una fila por plato

  const ListaProductos({super.key, required this.productos, this.columnas = 2});

  void _abrirDetalle(BuildContext context, Map<String, String> producto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleProducto(
          nombre: producto['nombre']!,
          precio: producto['precio']!,
          imagen: producto['imagen']!,
          descripcion: producto['descripcion']!,
        ),
      ),
    );
  }

  // Una fila por plato; cada una entra desde abajo, una después de otra
  Widget _filas(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < productos.length; i++)
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(milliseconds: 350 + math.min(i, 6) * 80),
            curve: Curves.easeOut,
            builder: (context, valor, hijo) => Opacity(
              opacity: valor,
              child: Transform.translate(
                offset: Offset(0, 28 * (1 - valor)),
                child: hijo,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FilaProducto(
                productoId: productos[i]['id']!,
                nombre: productos[i]['nombre']!,
                precio: productos[i]['precio']!,
                imagen: productos[i]['imagen']!,
                descripcion: productos[i]['descripcion'] ?? '',
                onInformacion: () => _abrirDetalle(context, productos[i]),
              ),
            ),
          ),
        const SizedBox(height: 90), // espacio para la burbuja del asistente
      ],
    );
  }

  // Cuadrícula de dos columnas (Home, "Lo más pedido")
  Widget _cuadricula(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const espacio = 12.0;
        final ancho = ((constraints.maxWidth - espacio) / 2).floorToDouble();
        const proporcion = 0.68; // ancho / alto

        return SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: espacio,
            runSpacing: espacio,
            children: productos.map((producto) {
              return SizedBox(
                width: ancho,
                height: ancho / proporcion,
                child: TarjetaProducto(
                  productoId: producto['id']!,
                  nombre: producto['nombre']!,
                  precio: producto['precio']!,
                  imagen: producto['imagen']!,
                  onInformacion: () => _abrirDetalle(context, producto),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Idioma.seleccionado,
      builder: (context, idioma, child) {
        return columnas == 1 ? _filas(context) : _cuadricula(context);
      },
    );
  }
}