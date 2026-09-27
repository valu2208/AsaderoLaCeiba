import 'package:flutter/material.dart';
import 'package:asadero/componentes/tarjeta_producto.dart';
import 'package:asadero/pantallas/detalle_producto.dart';

class ListaProductos extends StatelessWidget {
  final List<Map<String, String>> productos;

  const ListaProductos({
    super.key,
    required this.productos,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        itemCount: productos.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, index) {
          final producto = productos[index];

          return _tarjeta(context, producto, index);
        },
      ),
    );
  }

  Widget _tarjeta(
    BuildContext context,
    Map<String, String> producto,
    int index,
  ) {
    if (index == productos.length - 1 && productos.length.isOdd) {
      return Center(
        child: SizedBox(
          width: 150,
          height: 260,
          child: TarjetaProducto(
            nombre: producto['nombre']!,
            precio: producto['precio']!,
            imagen: producto['imagen']!,
            onInformacion: () => _abrirDetalle(context, producto),
          ),
        ),
      );
    }

    return TarjetaProducto(
      nombre: producto['nombre']!,
      precio: producto['precio']!,
      imagen: producto['imagen']!,
      onInformacion: () => _abrirDetalle(context, producto),
    );
  }

  void _abrirDetalle(
    BuildContext context,
    Map<String, String> producto,
  ) {
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
