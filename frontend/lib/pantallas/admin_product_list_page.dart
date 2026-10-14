import 'package:flutter/material.dart';
import '../models/producto_model.dart';
import '../services/admin_product_service.dart';
import '../componentes/admin_drawer.dart';
import '../componentes/dialogo_eliminar.dart';
import '../componentes/product_form_sheet.dart';

class AdminProductListPage extends StatefulWidget {
  const AdminProductListPage({super.key});

  @override
  State<AdminProductListPage> createState() => _AdminProductListPageState();
}

class _AdminProductListPageState extends State<AdminProductListPage> {
  final AdminProductService _productService = AdminProductService();
  late Future<List<ProductoModel>> _productosFuture;

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  void _cargarProductos() {
    setState(() {
      _productosFuture = _productService.obtenerProductos();
    });
  }

  void _abrirFormulario({ProductoModel? producto}) async {
    final resultado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => ProductFormSheet(producto: producto),
    );

    if (resultado == true) {
      _cargarProductos(); // Recarga la lista si se creó o editó exitosamente
    }
  }

  void _eliminarProducto(String id) async {
    final confirmar = await confirmarEliminacion(context);

    if (confirmar) {
      try {
        await _productService.eliminarProducto(id);
        _cargarProductos();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Producto eliminado correctamente'), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  // Es un ListView (no un Center) para que deslizar-para-recargar también funcione aquí
  Widget _mensaje(String texto) {
    return ListView(
      children: [
        const SizedBox(height: 160),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(texto, textAlign: TextAlign.center),
        ),
      ],
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
          _cargarProductos();
          try {
            await _productosFuture;
          } catch (_) {}
        },
        child: FutureBuilder<List<ProductoModel>>(
          future: _productosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _mensaje('Error al cargar productos:\n${snapshot.error}');
            }
            final productos = snapshot.data ?? [];
            if (productos.isEmpty) {
              return _mensaje('No hay productos registrados en el backend.');
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: producto.imagenUrl != null && producto.imagenUrl!.isNotEmpty
                        ? Image.network(producto.imagenUrl!, width: 50, height: 50, fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, size: 40))
                        : const Icon(Icons.fastfood, size: 40),
                    title: Text(producto.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('\$${producto.precio.toStringAsFixed(2)}\n${producto.descripcion}'),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _abrirFormulario(producto: producto),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _eliminarProducto(producto.id),
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
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}