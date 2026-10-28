import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import '../models/producto_model.dart';
import 'tarjeta_admin_producto.dart';

// Lista de productos del admin: carga, error, vacío y "jalar para refrescar"
class ListaAdminProductos extends StatelessWidget {
  final Future<List<ProductoModel>> productos;
  final String mensajeVacio;
  final Future<void> Function() onRefrescar;
  final void Function(String opcion, ProductoModel producto) onAccion;

  const ListaAdminProductos({
    super.key,
    required this.productos,
    required this.mensajeVacio,
    required this.onRefrescar,
    required this.onAccion,
  });

  // Texto dentro de un ListView (así también se puede refrescar jalando)
  Widget _mensaje(String texto) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            texto,
            textAlign: TextAlign.center,
            style: GoogleFonts.josefinSans(color: AppColors.earthBrown, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _contenido(AsyncSnapshot<List<ProductoModel>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator(color: AppColors.earthBrown));
    }
    if (snapshot.hasError) {
      return _mensaje(snapshot.error.toString().replaceAll('Exception: ', ''));
    }

    final lista = snapshot.data ?? [];
    if (lista.isEmpty) return _mensaje(mensajeVacio);

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 8, bottom: 90),
      itemCount: lista.length,
      itemBuilder: (context, index) => TarjetaAdminProducto(
        producto: lista[index],
        onAccion: (opcion) => onAccion(opcion, lista[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.earthBrown,
      onRefresh: onRefrescar,
      child: FutureBuilder<List<ProductoModel>>(
        future: productos,
        builder: (context, snapshot) => _contenido(snapshot),
      ),
    );
  }
}