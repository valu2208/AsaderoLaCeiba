
import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/formato.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/models/producto_model.dart';
import 'package:asadero/services/producto_service.dart';
import 'package:asadero/componentes/lista_productos.dart';

class CartaProductos extends StatefulWidget {
  final Future<List<ProductoModel>> Function()? cargar;
  final int columnas;

  const CartaProductos({
    super.key,
    this.cargar,
    this.columnas = 2,
  });

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

  String _nombreTraducido(ProductoModel p, String idioma) {
    if (idioma == 'English' && p.nombreEn.isNotEmpty) {
      return p.nombreEn;
    }

    if (idioma == 'Português' && p.nombrePt.isNotEmpty) {
      return p.nombrePt;
    }

    return p.nombre;
  }

  String _descripcionTraducida(ProductoModel p, String idioma) {
    if (idioma == 'English' && p.descripcionEn.isNotEmpty) {
      return p.descripcionEn;
    }

    if (idioma == 'Português' && p.descripcionPt.isNotEmpty) {
      return p.descripcionPt;
    }

    return p.descripcion;
  }

  Map<String, String> _aMapa(ProductoModel p, String idioma) => {
        'id': p.id,
        'nombre': _nombreTraducido(p, idioma),
        'nombre_original': p.nombre,
        'nombre_en': p.nombreEn,
        'nombre_pt': p.nombrePt,
        'precio': formatoPesos(p.precio),
        'imagen': p.imagenUrl ?? '',
        'descripcion': _descripcionTraducida(p, idioma),
      };

  Widget _mensaje(String mensaje, {bool reintentar = false}) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.earthBrown,
                fontSize: 16,
              ),
            ),
            if (reintentar)
              TextButton(
                onPressed: _recargar,
                child: Text(texto('reintentar')),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Idioma.seleccionado,
      builder: (context, idioma, child) {
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
              final error = snapshot.error.toString().replaceAll(
                    'Exception: ',
                    '',
                  );
              return _mensaje(error, reintentar: true);
            }

            final productos = snapshot.data ?? [];

            if (productos.isEmpty) {
              return _mensaje(texto('sin_platos_disponibles'));
            }

            return Expanded(
              child: RefreshIndicator(
                color: AppColors.earthBrown,
                onRefresh: _recargar,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    ListaProductos(
                      productos: productos
                          .map((p) => _aMapa(p, idioma))
                          .toList(),
                      columnas: widget.columnas,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
