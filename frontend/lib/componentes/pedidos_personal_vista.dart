import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:asadero/core/colores.dart';
import '../models/pedido_personal.dart';
import '../services/pedido_personal_service.dart';
import 'dialogo_mesa.dart';
import 'lista_pedidos_personal.dart';
import 'pestana_pedidos.dart';

// Pestañas con los pedidos del mesero o de cocina. Se actualiza solo cada 10 segundos
// y avisa (vibra y muestra un mensaje) cuando llega un pedido en estadoNuevo.
class PedidosPersonalVista extends StatefulWidget {
  final String rol; // 'mesero' o 'cocina'
  final List<PestanaPedidos> pestanas;
  final String estadoNuevo;

  const PedidosPersonalVista({
    super.key,
    required this.rol,
    required this.pestanas,
    required this.estadoNuevo,
  });

  @override
  State<PedidosPersonalVista> createState() => _PedidosPersonalVistaState();
}

class _PedidosPersonalVistaState extends State<PedidosPersonalVista> {
  final _servicio = PedidoPersonalService();
  final Set<int> _vistos = {};
  List<PedidoPersonal> _pedidos = [];
  String? _error;
  bool _cargando = true;
  bool _ocupado = false;
  bool _primeraCarga = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _cargar();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _cargar());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _aviso(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> _cargar() async {
    try {
      final pedidos = await _servicio.listar(widget.rol);
      if (!mounted) return;

      final nuevos = pedidos
          .where((p) => p.estado == widget.estadoNuevo && !_vistos.contains(p.id))
          .toList();

      if (!_primeraCarga && nuevos.isNotEmpty) {
        HapticFeedback.heavyImpact();
        _aviso('Nuevo pedido #${nuevos.first.id}');
      }

      _vistos.addAll(pedidos.map((p) => p.id));
      _primeraCarga = false;
      setState(() {
        _pedidos = pedidos;
        _error = null;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _cargando = false;
      });
    }
  }

  Future<void> _cambiar(PedidoPersonal pedido, String estado) async {
    // Al enviar a cocina el mesero debe indicar la mesa
    int? mesa;
    if (widget.rol == 'mesero' && estado == 'En cocina') {
      mesa = await pedirMesa(context, pedido);
      if (mesa == null) return;
    }

    setState(() => _ocupado = true);
    try {
      await _servicio.cambiarEstado(widget.rol, pedido.id, estado, mesa: mesa);
      await _cargar();
    } catch (e) {
      _aviso(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  List<PedidoPersonal> _de(PestanaPedidos pestana) =>
      _pedidos.where((p) => pestana.estados.contains(p.estado)).toList();

  Widget _contenido(PestanaPedidos pestana) {
    final lista = _de(pestana);

    return ListaPedidosPersonal(
      pedidos: lista,
      pestana: pestana,
      cargando: _cargando,
      ocupado: _ocupado,
      // el error solo se muestra si no hay nada que mostrar
      error: _pedidos.isEmpty ? _error : null,
      onRefrescar: _cargar,
      onCambiar: _cambiar,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.pestanas.length,
      child: Column(
        children: [
          TabBar(
            labelColor: AppColors.demonicPresence,
            unselectedLabelColor: AppColors.earthBrown.withValues(alpha: 0.6),
            indicatorColor: AppColors.redPrayerFlag,
            tabs: [
              for (final p in widget.pestanas)
                Tab(text: '${p.titulo} (${_de(p).length})'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [for (final p in widget.pestanas) _contenido(p)],
            ),
          ),
        ],
      ),
    );
  }
}