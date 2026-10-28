import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/estilo_campo.dart';
import '../models/producto_model.dart';
import '../services/admin_product_service.dart';
import 'admin_image_selector.dart';
import 'boton_formulario.dart';
import 'controlador_foto.dart';
import 'selector_dias_plato.dart';

class ProductFormSheet extends StatefulWidget {
  final ProductoModel? producto; // Si es nulo es CREAR, si tiene datos es EDITAR
  final String? categoria; // Menú: desayuno, almuerzo, fin_de_semana o gaseosas
  final bool? masPedido; // true = el plato sale en "Lo más pedido"
  final bool conDias; // true = pide los días de la semana (desayuno y almuerzo)
  final String? diaInicial; // día marcado al crear un plato nuevo

  const ProductFormSheet({
    super.key,
    this.producto,
    this.categoria,
    this.masPedido,
    this.conDias = false,
    this.diaInicial,
  });

  @override
  State<ProductFormSheet> createState() => _ProductFormSheetState();
}

class _ProductFormSheetState extends State<ProductFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _precioController;
  late TextEditingController _descripcionController;
  late List<String> _dias;

  final ControladorFoto _foto = ControladorFoto();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.producto?.nombre ?? '');
    _precioController = TextEditingController(text: widget.producto?.precio.toString() ?? '');
    _descripcionController = TextEditingController(text: widget.producto?.descripcion ?? '');
    _dias = [
      ...?widget.producto?.dias,
      if (widget.producto == null && widget.diaInicial != null) widget.diaInicial!,
    ];
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    _descripcionController.dispose();
    _foto.dispose();
    super.dispose();
  }

  void _aviso(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto), backgroundColor: Colors.red),
    );
  }

  Future<void> _guardarProducto() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.conDias && _dias.isEmpty) return _aviso('Elige al menos un día');

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
        categoria: widget.categoria,
        masPedido: widget.masPedido,
        dias: widget.conDias ? _dias : null,
      );
      if (mounted) Navigator.pop(context, true); // true = se guardó
    } catch (e) {
      _aviso(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.producto == null ? 'Nuevo plato' : 'Editar plato',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.earthBrown),
              ),
              AdminImageSelector(
                controlador: _foto,
                imagenUrl: widget.producto?.imagenUrl,
                habilitado: !_isLoading,
              ),
              TextFormField(
                controller: _nombreController,
                decoration: decoracionCampo('Nombre del plato'),
                validator: (value) => (value ?? '').trim().isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _precioController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: decoracionCampo('Precio (\$)'),
                validator: (value) => double.tryParse((value ?? '').trim()) == null ? 'Ingresa un número válido' : null,
              ),
              TextFormField(
                controller: _descripcionController,
                maxLines: 3,
                decoration: decoracionCampo('Descripción'),
              ),
              if (widget.conDias)
                SelectorDiasPlato(
                  seleccionados: _dias,
                  onCambio: (nuevos) => setState(() => _dias = nuevos),
                ),
              BotonFormulario(
                texto: widget.producto == null ? 'Crear plato' : 'Guardar cambios',
                cargando: _isLoading,
                onPressed: _guardarProducto,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}