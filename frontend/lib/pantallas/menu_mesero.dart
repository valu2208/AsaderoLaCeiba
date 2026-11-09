import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/dias_semana.dart';
import '../models/producto_model.dart';
import '../services/producto_service.dart';
import '../componentes/filtro_chips.dart';
import '../componentes/fondo_degradado.dart';
import '../componentes/personal_drawer.dart';
import '../componentes/tarjeta_admin_producto.dart';

// Menú del día para el mesero (solo lectura): lo mismo que ve el cliente hoy
class MenuMesero extends StatefulWidget {
  const MenuMesero({super.key});

  @override
  State<MenuMesero> createState() => _MenuMeseroState();
}

class _MenuMeseroState extends State<MenuMesero> {
  static const _categorias = {
    'desayuno': 'Desayuno',
    'almuerzo': 'Almuerzo',
    'gaseosas': 'Gaseosas',
    'fin_de_semana': 'Fin de semana',
  };

  late Future<List<ProductoModel>> _productos;
  String _categoria = 'desayuno';

  // Solo desayuno y almuerzo cambian según el día
  bool get _porDia => _categoria == 'desayuno' || _categoria == 'almuerzo';

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() {
    _productos = ProductoService().obtenerPorCategoria(
      _categoria,
      dia: _porDia ? diaDeHoy() : null,
    );
  }

  Widget _mensaje(String texto) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: GoogleFonts.josefinSans(color: AppColors.earthBrown, fontSize: 16),
        ),
      ),
    );
  }

  Widget _lista(AsyncSnapshot<List<ProductoModel>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator(color: AppColors.earthBrown));
    }
    if (snapshot.hasError) {
      return _mensaje(snapshot.error.toString().replaceAll('Exception: ', ''));
    }

    final lista = snapshot.data ?? [];
    if (lista.isEmpty) {
      return _mensaje('No hay platos de ${_categorias[_categoria]} para hoy.');
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 4, bottom: 24),
      itemCount: lista.length,
      itemBuilder: (context, indice) => TarjetaAdminProducto(producto: lista[indice]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú del día', style: GoogleFonts.kronaOne(fontSize: 16)),
        centerTitle: true,
        backgroundColor: AppColors.earthBrown,
        foregroundColor: AppColors.goldSand,
      ),
      drawer: const PersonalDrawer(rol: 'mesero', actual: 'menu'),
      body: FondoDegradado(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'Hoy es ${nombresDias[diaDeHoy()]}',
                style: GoogleFonts.josefinSans(
                  color: AppColors.earthBrown,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FiltroChips(
              opciones: _categorias,
              seleccionado: _categoria,
              onCambio: (valor) => setState(() {
                _categoria = valor;
                _cargar();
              }),
            ),
            Expanded(
              child: FutureBuilder<List<ProductoModel>>(
                future: _productos,
                builder: (context, snapshot) => _lista(snapshot),
              ),
            ),
          ],
        ),
      ),
    );
  }
}