import 'package:flutter/material.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/componentes/tarjeta_producto.dart';
import 'package:asadero/pantallas/detalle_producto.dart';

class ListaProductos extends StatelessWidget {
  final List<Map<String, String>> productos;

  const ListaProductos({super.key, required this.productos});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Idioma.seleccionado,
      builder: (context, idioma, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            const espacio = 12.0;

            final ancho = ((constraints.maxWidth - espacio) / 2)
                .floorToDouble();

            return SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: espacio,
                runSpacing: espacio,
                children: productos.map((producto) {
                  return SizedBox(
                    width: ancho,
                    height: ancho / 0.68,
                    child: TarjetaProducto(
                      productoId: producto['id']!,
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
