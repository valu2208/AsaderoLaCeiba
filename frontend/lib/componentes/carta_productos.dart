import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/formato.dart';
import 'package:asadero/models/producto_model.dart';
import 'package:asadero/services/producto_service.dart';
import 'package:asadero/componentes/lista_productos.dart';

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

  Future<void> _recargar() async {
    setState(() {
      _productos = ProductoService().obtenerProductos();
    });

    await _productos;
  }

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
              style: const TextStyle(
                color: AppColors.earthBrown,
                fontSize: 16,
              ),
            ),
            if (reintentar)
              TextButton(
                onPressed: _recargar,
                child: const Text('Reintentar'),
              ),
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
              child: CircularProgressIndicator(
                color: AppColors.earthBrown,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          final error =
              snapshot.error.toString().replaceAll('Exception: ', '');
          return _mensaje(error, reintentar: true);
        }

        final productos = snapshot.data ?? [];

        if (productos.isEmpty) {
          return _mensaje('Aún no hay platos disponibles');
        }

        return Expanded(
          child: RefreshIndicator(
            color: AppColors.earthBrown,
            onRefresh: _recargar,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                ListaProductos(
                  productos: productos.map(_aMapa).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}