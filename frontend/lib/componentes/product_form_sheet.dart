import 'package:flutter/material.dart';
import '../models/producto_model.dart';
import '../services/admin_product_service.dart';
import 'admin_image_selector.dart';
import 'controlador_foto.dart';

class ProductFormSheet extends StatefulWidget {
  final ProductoModel? producto; // Si es nulo es CREAR, si tiene datos es EDITAR

  const ProductFormSheet({super.key, this.producto});

  @override
  State<ProductFormSheet> createState() => _ProductFormSheetState();
}

class _ProductFormSheetState extends State<ProductFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _precioController;
  late TextEditingController _descripcionController;

  final ControladorFoto _foto = ControladorFoto();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.producto?.nombre ?? '');
    _precioController = TextEditingController(text: widget.producto?.precio.toString() ?? '');
    _descripcionController = TextEditingController(text: widget.producto?.descripcion ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    _descripcionController.dispose();
    _foto.dispose();
    super.dispose();
  }

  Future<void> _guardarProducto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final hayFoto = _foto.imagen != null || (widget.producto?.imagenUrl?.isNotEmpty ?? false);
      final imagen = await _foto.archivoParaSubir(hayFoto: hayFoto);
      await AdminProductService().guardarProducto(
        id: widget.producto?.id,
        nombre: _nombreController.text.trim(),
        precio: _precioController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        imagen: imagen, // null = se conserva la foto actual
      );
      if (mounted) Navigator.pop(context, true); // true = se guardó
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.producto == null ? 'Nuevo Plato / Producto' : 'Editar Producto',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              AdminImageSelector(
                controlador: _foto,
                imagenUrl: widget.producto?.imagenUrl,
                habilitado: !_isLoading,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre del plato', border: OutlineInputBorder()),
                validator: (value) => (value ?? '').trim().isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _precioController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Precio (\$)', border: OutlineInputBorder()),
                validator: (value) => double.tryParse((value ?? '').trim()) == null ? 'Ingresa un número válido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descripcionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Descripción', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: _isLoading ? null : _guardarProducto,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(widget.producto == null ? 'Crear Producto' : 'Guardar Cambios'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}