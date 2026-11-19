import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import '../models/pedido_personal.dart';
import '../pantallas/detalle_pedido_personal.dart';
import 'pestana_pedidos.dart';
import 'tarjeta_pedido_personal.dart';

// Lista de una pestaña: carga, error, vacío y "jalar para refrescar"
class ListaPedidosPersonal extends StatelessWidget {
  final List<PedidoPersonal> pedidos; // ya filtrados para esta pestaña
  final PestanaPedidos pestana;
  final bool cargando;
  final bool ocupado; // true = botones desactivados mientras se envía
  final String? error;
  final Future<void> Function() onRefrescar;
  final void Function(PedidoPersonal pedido, String estado) onCambiar;

  const ListaPedidosPersonal({
    super.key,
    required this.pedidos,
    required this.pestana,
    required this.cargando,
    required this.ocupado,
    required this.error,
    required this.onRefrescar,
    required this.onCambiar,
  });

  // Texto dentro de un ListView (así también se puede refrescar jalando)
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

  // Lo que hace el botón de la card (y del detalle) para este pedido
  VoidCallback? _accionDe(PedidoPersonal pedido) {
    if (pestana.estadoSiguiente == null || ocupado) return null;
    return () => onCambiar(pedido, pestana.estadoSiguiente!);
  }

  void _abrirDetalle(BuildContext context, PedidoPersonal pedido) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetallePedidoPersonal(
          pedido: pedido,
          accion: pestana.accion,
          onAccion: _accionDe(pedido),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Center(child: CircularProgressIndicator(color: AppColors.earthBrown));
    }

    return RefreshIndicator(
      color: AppColors.earthBrown,
      onRefresh: onRefrescar,
      child: pedidos.isEmpty
          ? _mensaje(error ?? pestana.vacio)
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              itemCount: pedidos.length,
              itemBuilder: (context, indice) {
                final pedido = pedidos[indice];
                return TarjetaPedidoPersonal(
                  pedido: pedido,
                  accion: pestana.accion,
                  ocupado: ocupado,
                  onAccion: _accionDe(pedido),
                  onTap: () => _abrirDetalle(context, pedido),
                );
              },
            ),
    );
  }
}