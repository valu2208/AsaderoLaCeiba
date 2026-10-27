import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/dias_semana.dart';
import '../models/producto_model.dart';
import '../services/admin_product_service.dart';
import '../componentes/acciones_producto.dart';
import '../componentes/admin_drawer.dart';
import '../componentes/barra_dias.dart';
import '../componentes/filtro_chips.dart';
import '../componentes/fondo_degradado.dart';
import '../componentes/lista_admin_productos.dart';
import '../componentes/product_form_sheet.dart';

// Gestión del Menú: platos por categoría (y por día en desayuno y almuerzo)
class AdminMenuPage extends StatefulWidget {
  const AdminMenuPage({super.key});

  @override
  State<AdminMenuPage> createState() => _AdminMenuPageState();
}

class _AdminMenuPageState extends State<AdminMenuPage> {
  static const _categorias = {
    'desayuno': 'Desayuno',
    'almuerzo': 'Almuerzo',
    'fin_de_semana': 'Fin de semana',
    'gaseosas': 'Gaseosas',
  };

  final _service = AdminProductService();
  late Future<List<ProductoModel>> _productos;
  String _categoria = 'desayuno';
  String _dia = diaDeHoy();

  // Solo desayuno y almuerzo cambian según el día
  bool get _usaDias => _categoria == 'desayuno' || _categoria == 'almuerzo';

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() {
    _productos = _service.obtenerProductos(
      categoria: _categoria,
      dia: _usaDias ? _dia : null,
      masPedido: false, // el menú no incluye "Lo más pedido"
    );
  }

  void _recargar() {
    if (mounted) setState(_cargar);
  }

  Future<void> _formulario({ProductoModel? producto}) async {
    final guardado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.goldSand,
      builder: (_) => ProductFormSheet(
        producto: producto,
        categoria: _categoria,
        masPedido: false,
        conDias: _usaDias,
        diaInicial: _dia,
      ),
    );

    if (guardado == true) _recargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión del Menú', style: GoogleFonts.josefinSans(fontSize: 22)),
        centerTitle: true,
        backgroundColor: AppColors.earthBrown,
        foregroundColor: AppColors.goldSand,
      ),
      drawer: const AdminDrawer(actual: 'menu'),
      body: FondoDegradado(
        child: Column(
          children: [
            FiltroChips(
              opciones: _categorias,
              seleccionado: _categoria,
              onCambio: (valor) => setState(() {
                _categoria = valor;
                _cargar();
              }),
            ),
            if (_usaDias)
              BarraDias(
                seleccionado: _dia,
                onCambio: (valor) => setState(() {
                  _dia = valor;
                  _cargar();
                }),
              ),
            Expanded(
              child: ListaAdminProductos(
                productos: _productos,
                mensajeVacio: 'No hay platos aquí todavía. Toca + para agregar uno.',
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
          ],
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