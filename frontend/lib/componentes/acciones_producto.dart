import 'package:flutter/material.dart';
import '../models/producto_model.dart';
import '../services/admin_product_service.dart';
import 'dialogo_eliminar.dart';

// Lo que pasa al elegir una opción del menú ⋮ de un producto en el admin.
// editar: abre el formulario | alTerminar: recarga la lista
Future<void> accionProducto(
  BuildContext context,
  String opcion,
  ProductoModel p, {
  required VoidCallback editar,
  required VoidCallback alTerminar,
}) async {
  final service = AdminProductService();

  void aviso(String texto) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> ejecutar(Future<void> Function() accion, {String? ok}) async {
    try {
      await accion();
      alTerminar();
      if (ok != null) aviso(ok);
    } catch (e) {
      aviso(e.toString().replaceAll('Exception: ', ''));
    }
  }

  switch (opcion) {
    case 'editar':
      editar();
    case 'estado':
      if (!p.activo) return ejecutar(() => service.activarProducto(p.id));
      if (!await confirmarEliminacion(context, nombre: p.nombre)) return;
      return ejecutar(() => service.eliminarProducto(p.id));
    case 'eliminar':
      if (!context.mounted) return;
      if (!await confirmarEliminacionDefinitiva(context, p.nombre)) return;
      return ejecutar(
        () => service.eliminarProductoDefinitivamente(p.id),
        ok: 'Producto eliminado definitivamente',
      );
  }
}