import 'package:flutter/material.dart';
import '../models/producto_model.dart';
import '../services/admin_product_service.dart';
import '../componentes/admin_drawer.dart';
import '../componentes/dialogo_eliminar.dart';
import '../componentes/product_form_sheet.dart';

class AdminProductListPage extends StatefulWidget {
  const AdminProductListPage({super.key});

  @override
  State<AdminProductListPage> createState() =>
      _AdminProductListPageState();
}

class _AdminProductListPageState
    extends State<AdminProductListPage> {
  final _service = AdminProductService();
  late Future<List<ProductoModel>> _productos;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() {
    _productos = _service.obtenerProductos();
  }

  Future<void> _formulario({ProductoModel? producto}) async {
    final resultado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ProductFormSheet(producto: producto),
    );

    if (resultado == true && mounted) {
      setState(_cargar);
    }
  }

  Future<void> _desactivar(String id) async {
    if (!await confirmarEliminacion(context) || !mounted) return;

    try {
      await _service.eliminarProducto(id);
      if (mounted) setState(_cargar);
    } catch (e) {
      _aviso('$e');
    }
  }

  Future<void> _activar(String id) async {
    try {
      await _service.activarProducto(id);
      if (mounted) setState(_cargar);
    } catch (e) {
      _aviso('$e');
    }
  }

  Future<void> _eliminar(String id, String nombre) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar definitivamente'),
        content: Text(
          '¿Eliminar "$nombre" permanentemente? '
          'Si tiene pedidos asociados, no podrá borrarse.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    try {
      await _service.eliminarProductoDefinitivamente(id);
      if (!mounted) return;
      setState(_cargar);
      _aviso('Producto eliminado definitivamente');
    } catch (e) {
      _aviso('$e');
    }
  }

  void _aviso(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Admin · Asadero La Ceiba'),
        backgroundColor: Colors.orangeAccent,
      ),
      drawer: const AdminDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(_cargar);
          try {
            await _productos;
          } catch (_) {}
        },
        child: FutureBuilder<List<ProductoModel>>(
          future: _productos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return ListView(
                children: [
                  Center(child: Text('Error: ${snapshot.error}')),
                ],
              );
            }

            final lista = snapshot.data ?? [];

            if (lista.isEmpty) {
              return const Center(
                child: Text('No hay productos registrados.'),
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final p = lista[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: p.imagenUrl != null &&
                            p.imagenUrl!.isNotEmpty
                        ? Image.network(
                            p.imagenUrl!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.fastfood),
                          )
                        : const Icon(Icons.fastfood),
                    title: Text(p.nombre),
                    subtitle: Text(
                      '\$${p.precio.toStringAsFixed(2)}\n'
                      '${p.descripcion}\n'
                      'Estado: ${p.activo ? "Activo" : "Inactivo"}',
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (opcion) {
                        switch (opcion) {
                          case 'editar':
                            _formulario(producto: p);
                          case 'estado':
                            p.activo
                                ? _desactivar(p.id)
                                : _activar(p.id);
                          case 'eliminar':
                            _eliminar(p.id, p.nombre);
                        }
                      },
                      itemBuilder: (_) => [
                        if (p.activo)
                          const PopupMenuItem(
                            value: 'editar',
                            child: Text('Editar'),
                          ),
                        PopupMenuItem(
                          value: 'estado',
                          child: Text(
                            p.activo ? 'Desactivar' : 'Reactivar',
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'eliminar',
                          child: Text('Eliminar definitivamente'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () => _formulario(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
