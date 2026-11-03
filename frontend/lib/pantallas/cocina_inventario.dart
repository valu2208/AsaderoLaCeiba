import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import '../models/ingrediente.dart';
import '../services/inventario_service.dart';
import '../componentes/dialogo_stock.dart';
import '../componentes/fondo_degradado.dart';
import '../componentes/personal_drawer.dart';
import '../componentes/tarjeta_ingrediente.dart';

// Suministro de ingredientes: los que están bajos salen primero
class CocinaInventario extends StatefulWidget {
  const CocinaInventario({super.key});

  @override
  State<CocinaInventario> createState() => _CocinaInventarioState();
}

class _CocinaInventarioState extends State<CocinaInventario> {
  final _servicio = InventarioService();
  late Future<List<Ingrediente>> _ingredientes;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() {
    _ingredientes = _servicio.listar().then((lista) {
      // Bajos primero y luego por nombre
      lista.sort((a, b) {
        if (a.bajo != b.bajo) return a.bajo ? -1 : 1;
        return a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase());
      });
      return lista;
    });
  }

  void _aviso(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> _editar(Ingrediente ingrediente) async {
    final nuevo = await pedirStock(context, ingrediente);
    if (nuevo == null) return;

    try {
      await _servicio.actualizarStock(ingrediente.id, nuevo);
      if (!mounted) return;
      setState(_cargar);
      _aviso('${ingrediente.nombre} actualizado');
    } catch (e) {
      _aviso(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Widget _mensaje(String texto) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
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

  Widget _lista(AsyncSnapshot<List<Ingrediente>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator(color: AppColors.earthBrown));
    }
    if (snapshot.hasError) {
      return _mensaje(snapshot.error.toString().replaceAll('Exception: ', ''));
    }

    final lista = snapshot.data ?? [];
    if (lista.isEmpty) return _mensaje('Todavía no hay ingredientes registrados.');

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: lista.length,
      itemBuilder: (context, indice) => TarjetaIngrediente(
        ingrediente: lista[indice],
        onTap: () => _editar(lista[indice]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suministro', style: GoogleFonts.kronaOne(fontSize: 16)),
        centerTitle: true,
        backgroundColor: AppColors.earthBrown,
        foregroundColor: AppColors.goldSand,
      ),
      drawer: const PersonalDrawer(rol: 'cocinero', actual: 'suministro'),
      body: FondoDegradado(
        child: RefreshIndicator(
          color: AppColors.earthBrown,
          onRefresh: () async {
            setState(_cargar);
            try {
              await _ingredientes;
            } catch (_) {}
          },
          child: FutureBuilder<List<Ingrediente>>(
            future: _ingredientes,
            builder: (context, snapshot) => _lista(snapshot),
          ),
        ),
      ),
    );
  }
}