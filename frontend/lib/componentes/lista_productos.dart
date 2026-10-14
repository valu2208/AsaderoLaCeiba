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
        return Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const espacio = 12.0;

              if (constraints.maxWidth <= espacio) {
                return const SizedBox.shrink();
              }

              final anchoTarjeta = ((constraints.maxWidth - espacio) / 2)
                  .floorToDouble();
              final altoTarjeta = anchoTarjeta / 0.78;

              return SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: espacio,
                  runSpacing: espacio,
                  children: productos.map((producto) {
                    return SizedBox(
                      width: anchoTarjeta,
                      height: altoTarjeta,
                      child: TarjetaProducto(
                        nombre: producto['nombre']!,
                        precio: producto['precio']!,
                        imagen: producto['imagen']!,
                        onInformacion: () {
                          _abrirDetalle(context, producto);
                        },
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _abrirDetalle(BuildContext context, Map<String, String> producto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalleProducto(
          nombre: producto['nombre']!,
          precio: producto['precio']!,
          imagen: producto['imagen']!,
          descripcion: producto['descripcion']!,
        ),
      ),
    );
  }
}
