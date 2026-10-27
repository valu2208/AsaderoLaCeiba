import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import '../models/producto_model.dart';
import '../services/admin_product_service.dart';
import '../componentes/acciones_producto.dart';
import '../componentes/admin_drawer.dart';
import '../componentes/fondo_degradado.dart';
import '../componentes/lista_admin_productos.dart';
import '../componentes/product_form_sheet.dart';

// Gestionar productos = solo los que salen en "Lo más pedido" del Home
class AdminProductListPage extends StatefulWidget {
  const AdminProductListPage({super.key});

  @override
  State<AdminProductListPage> createState() => _AdminProductListPageState();
}

class _AdminProductListPageState extends State<AdminProductListPage> {
  final _service = AdminProductService();
  late Future<List<ProductoModel>> _productos;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() {
    _productos = _service.obtenerProductos(masPedido: true);
  }

  void _recargar() {
    if (mounted) setState(_cargar);
  }

  Future<void> _formulario({ProductoModel? producto}) async {
    final guardado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.goldSand,
      builder: (_) => ProductFormSheet(producto: producto, masPedido: true),
    );

    if (guardado == true) _recargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lo más pedido', style: GoogleFonts.kronaOne(fontSize: 16)),
        centerTitle: true,
        backgroundColor: AppColors.earthBrown,
        foregroundColor: AppColors.goldSand,
      ),
      drawer: const AdminDrawer(),
      body: FondoDegradado(
        child: ListaAdminProductos(
          productos: _productos,
          mensajeVacio: 'Aún no hay platos en "Lo más pedido". Toca + para agregar uno.',
          onRefrescar: () async {
            _recargar();
            try {
              await _productos;
            } catch (_) {}
          },
          onAccion: (opcion, p) => accionProducto(
            context,
            opcion,
            p,
            editar: () => _formulario(producto: p),
            alTerminar: _recargar,
          ),
        ),
      ),
      // Crema con "+" vino: resalta sobre el fondo rojo
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.goldSand,
        foregroundColor: AppColors.demonicPresence,
        onPressed: () => _formulario(),
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}