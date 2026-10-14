import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/formato.dart';
import 'package:asadero/models/producto_model.dart';
import 'package:asadero/services/producto_service.dart';
import 'package:asadero/componentes/lista_productos.dart';

// Carta del cliente: pide los platos al backend (los mismos que administra el
// panel) y los muestra con ListaProductos. Va dentro de una Column, como ListaProductos.
class CartaProductos extends StatefulWidget {
  const CartaProductos({super.key});

  @override
  State<CartaProductos> createState() => _CartaProductosState();
}

class _CartaProductosState extends State<CartaProductos> {
  late Future<List<ProductoModel>> _productos;

  @override
  void initState() {
    super.initState();
    _productos = ProductoService().obtenerProductos();
  }

  void _recargar() {
    setState(() {
      _productos = ProductoService().obtenerProductos();
    });
  }

  // ListaProductos trabaja con mapas de texto, así que se convierte cada producto
  Map<String, String> _aMapa(ProductoModel p) => {
        'nombre': p.nombre,
        'precio': formatoPesos(p.precio),
        'imagen': p.imagenUrl ?? '',
        'descripcion': p.descripcion,
      };

  Widget _mensaje(String texto, {bool reintentar = false}) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              texto,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.earthBrown, fontSize: 16),
            ),
            if (reintentar)
              TextButton(onPressed: _recargar, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductoModel>>(
      future: _productos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(color: AppColors.earthBrown),
            ),
          );
        }
        if (snapshot.hasError) {
          final error = snapshot.error.toString().replaceAll('Exception: ', '');
          return _mensaje(error, reintentar: true);
        }
        final productos = snapshot.data ?? [];
        if (productos.isEmpty) return _mensaje('Aún no hay platos disponibles');
        return ListaProductos(productos: productos.map(_aMapa).toList());
      },
    );
  }
}