import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import '../models/reporte.dart';
import '../services/reporte_service.dart';
import '../componentes/admin_drawer.dart';
import '../componentes/filtro_chips.dart';
import '../componentes/fondo_degradado.dart';
import '../componentes/grafico_barras.dart';
import '../componentes/lista_mas_vendidos.dart';
import '../componentes/resumen_reporte.dart';
import '../componentes/selector_fecha.dart';

// Reportes del admin: ventas del día, mes o año y platos más vendidos
class AdminReportesPage extends StatefulWidget {
  const AdminReportesPage({super.key});

  @override
  State<AdminReportesPage> createState() => _AdminReportesPageState();
}

class _AdminReportesPageState extends State<AdminReportesPage> {
  static const _periodos = {'dia': 'Día', 'mes': 'Mes', 'anio': 'Año'};

  final _servicio = ReporteService();
  late Future<Reporte> _reporte;
  String _periodo = 'dia';
  DateTime _fecha = _hoy();

  static DateTime _hoy() {
    final ahora = DateTime.now();
    return DateTime(ahora.year, ahora.month, ahora.day);
  }

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() => _reporte = _servicio.obtener(_periodo, _fecha);

  Future<void> _refrescar() async {
    setState(_cargar);
    try {
      await _reporte;
    } catch (_) {}
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

  Widget _contenido(AsyncSnapshot<Reporte> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator(color: AppColors.earthBrown));
    }
    if (snapshot.hasError) {
      return _mensaje(snapshot.error.toString().replaceAll('Exception: ', ''));
    }

    final reporte = snapshot.data!;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        ResumenReporte(reporte: reporte),
        GraficoBarras(periodo: _periodo, serie: reporte.serie),
        ListaMasVendidos(platos: reporte.top),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reportes', style: GoogleFonts.kronaOne(fontSize: 16)),
        centerTitle: true,
        backgroundColor: AppColors.earthBrown,
        foregroundColor: AppColors.goldSand,
      ),
      drawer: const AdminDrawer(actual: 'reportes'),
      body: FondoDegradado(
        child: Column(
          children: [
            FiltroChips(
              opciones: _periodos,
              seleccionado: _periodo,
              onCambio: (valor) => setState(() {
                _periodo = valor;
                _cargar();
              }),
            ),
            SelectorFecha(
              periodo: _periodo,
              fecha: _fecha,
              onCambio: (nueva) => setState(() {
                _fecha = nueva;
                _cargar();
              }),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.earthBrown,
                onRefresh: _refrescar,
                child: FutureBuilder<Reporte>(
                  future: _reporte,
                  builder: (context, snapshot) => _contenido(snapshot),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}