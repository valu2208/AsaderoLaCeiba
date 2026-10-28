import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/formato.dart';
import 'package:asadero/models/producto_model.dart';
import 'package:asadero/services/producto_service.dart';
import 'package:asadero/componentes/lista_productos.dart';

class CartaProductos extends StatefulWidget {
  // Qué lista cargar. Sin nada = "Lo más pedido" (Home).
  // El Menú le pasa la categoría: () => ProductoService().obtenerPorCategoria('almuerzo')
  final Future<List<ProductoModel>> Function()? cargar;
  final int columnas; // 2 = Home, 1 = Menú (cards más grandes, una por fila)

  const CartaProductos({super.key, this.cargar, this.columnas = 2});

  @override
  State<CartaProductos> createState() => _CartaProductosState();
}

class _CartaProductosState extends State<CartaProductos> {
  late Future<List<ProductoModel>> _productos;

  Future<List<ProductoModel>> _cargar() =>
      (widget.cargar ?? ProductoService().obtenerMasPedidos)();

  @override
  void initState() {
    super.initState();
    _productos = _cargar();
  }

  Future<void> _recargar() async {
    setState(() {
      _productos = _cargar();
    });

    await _productos;
  }

  Map<String, String> _aMapa(ProductoModel p) => {
    'id': p.id,
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
<<<<<<< HEAD
                ListaProductos(productos: productos.map(_aMapa).toList()),
=======
                ListaProductos(
                  columnas: widget.columnas,
                  productos: productos.map(_aMapa).toList(),
                ),
>>>>>>> origin/main
              ],
            ),
          ),
        );
      },
    );
  }
}