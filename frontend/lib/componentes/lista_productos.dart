import 'package:flutter/material.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/componentes/tarjeta_producto.dart';
import 'package:asadero/pantallas/detalle_producto.dart';

class ListaProductos extends StatelessWidget {
  final List<Map<String, String>> productos;
  final int columnas; // 2 = como en el Home, 1 = una card mediana por fila

  const ListaProductos({super.key, required this.productos, this.columnas = 2});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Idioma.seleccionado,
      builder: (context, idioma, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            const espacio = 12.0;

            final ancho = (columnas == 1
                    ? constraints.maxWidth * 0.78
                    : (constraints.maxWidth - espacio) / 2)
                .floorToDouble();
            final proporcion = columnas == 1 ? 0.9 : 0.68; // ancho / alto

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
                      nombre: producto['nombre']!,
                      precio: producto['precio']!,
                      imagen: producto['imagen']!,
                      onInformacion: () {
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
                      },
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }
}