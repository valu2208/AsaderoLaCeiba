import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import '../componentes/admin_drawer.dart';
import '../componentes/fondo_degradado.dart';
import '../componentes/tarjeta_comprobante.dart';
import '../services/pago_service.dart';

class AdminPagosPage extends StatefulWidget {
  const AdminPagosPage({super.key});

  @override
  State<AdminPagosPage> createState() => _AdminPagosPageState();
}

class _AdminPagosPageState extends State<AdminPagosPage> {
  final _servicio = PagoService();
  List<Map<String, dynamic>> _pagos = [];
  bool _cargando = true;
  bool _ocupado = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final lista = await _servicio.pendientes();
      if (!mounted) return;
      setState(() {
        _pagos = lista;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _cargando = false;
      });
    }
  }

  Future<void> _revisar(int id, String estado) async {
    setState(() => _ocupado = true);
    try {
      await _servicio.revisar(id, estado);
      await _cargar();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  Widget _contenido() {
    if (_cargando) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(child: Text(_error!, textAlign: TextAlign.center));
    }
    if (_pagos.isEmpty) {
      return const Center(child: Text('No hay comprobantes por revisar.'));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final pago in _pagos)
          TarjetaComprobante(
            pago: pago,
            ocupado: _ocupado,
            onAprobar: () => _revisar(pago['id'], 'Aprobado'),
            onRechazar: () => _revisar(pago['id'], 'Rechazado'),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagos', style: GoogleFonts.kronaOne(fontSize: 16)),
        centerTitle: true,
        backgroundColor: AppColors.earthBrown,
        foregroundColor: AppColors.goldSand,
        actions: [
          IconButton(onPressed: _cargar, icon: const Icon(Icons.refresh)),
        ],
      ),
      drawer: const AdminDrawer(actual: 'pagos'),
      body: FondoDegradado(
        child: RefreshIndicator(onRefresh: _cargar, child: _contenido()),
      ),
    );
  }
}