import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import '../models/ingrediente.dart';
import '../services/inventario_service.dart';
import '../componentes/admin_drawer.dart';
import '../componentes/cabecera_inventario.dart';
import '../componentes/dialogo_ingrediente.dart';
import '../componentes/dialogo_stock.dart';
import '../componentes/fondo_degradado.dart';
import '../componentes/lista_ingredientes.dart';
import '../componentes/opciones_ingrediente.dart';

// Inventario del admin: ver, crear, editar, ajustar y eliminar ingredientes
class AdminInventarioPage extends StatefulWidget {
  const AdminInventarioPage({super.key});

  @override
  State<AdminInventarioPage> createState() => _AdminInventarioPageState();
}

class _AdminInventarioPageState extends State<AdminInventarioPage> {
  final _servicio = InventarioService();
  late Future<List<Ingrediente>> _ingredientes;
  String _filtro = 'todos';

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() => _ingredientes = _servicio.listar();

  Future<void> _refrescar() async {
    setState(_cargar);
    try {
      await _ingredientes;
    } catch (_) {}
  }

  void _aviso(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  // Ejecuta una acción del servicio, avisa el resultado y recarga la lista
  Future<void> _ejecutar(Future<void> Function() accion, String exito) async {
    try {
      await accion();
      if (!mounted) return;
      setState(_cargar);
      _aviso(exito);
    } catch (e) {
      _aviso(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> _crear() async {
    final d = await pedirIngrediente(context);
    if (d == null) return;
    await _ejecutar(
      () => _servicio.crear(
        nombre: d.nombre,
        unidad: d.unidad,
        stockActual: d.stockActual,
        stockMinimo: d.stockMinimo,
      ),
      '${d.nombre} creado',
    );
  }

  Future<void> _ajustar(Ingrediente i) async {
    final nuevo = await pedirStock(context, i);
    if (nuevo == null) return;
    await _ejecutar(
      () => _servicio.actualizarStock(i.id, nuevo),
      '${i.nombre} actualizado',
    );
  }

  Future<void> _editar(Ingrediente i) async {
    final d = await pedirIngrediente(context, ingrediente: i);
    if (d == null) return;
    await _ejecutar(
      () => _servicio.editar(
        i.id,
        nombre: d.nombre,
        unidad: d.unidad,
        stockMinimo: d.stockMinimo,
      ),
      '${i.nombre} editado',
    );
  }

  Future<void> _eliminar(Ingrediente i) async {
    if (!await confirmarEliminarIngrediente(context, i.nombre)) return;
    await _ejecutar(() => _servicio.eliminar(i.id), '${i.nombre} eliminado');
  }

  Future<void> _opciones(Ingrediente i) async {
    final opcion = await elegirOpcionIngrediente(context);
    if (!mounted) return;
    if (opcion == 'stock') _ajustar(i);
    if (opcion == 'editar') _editar(i);
    if (opcion == 'eliminar') _eliminar(i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventario', style: GoogleFonts.kronaOne(fontSize: 16)),
        centerTitle: true,
        backgroundColor: AppColors.earthBrown,
        foregroundColor: AppColors.goldSand,
      ),
      drawer: const AdminDrawer(actual: 'inventario'),
      body: FondoDegradado(
        child: Column(
          children: [
            CabeceraInventario(
              ingredientes: _ingredientes,
              filtro: _filtro,
              onFiltro: (valor) => setState(() => _filtro = valor),
            ),
            Expanded(
              child: ListaIngredientes(
                ingredientes: _ingredientes,
                filtro: _filtro,
                mensajeVacio: 'Todavía no hay ingredientes. Toca + para agregar uno.',
                onRefrescar: _refrescar,
                onTap: _opciones,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.goldSand,
        foregroundColor: AppColors.demonicPresence,
        onPressed: _crear,
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}