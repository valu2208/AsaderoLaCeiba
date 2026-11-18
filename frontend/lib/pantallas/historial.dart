import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/componentes/barra_nav_inferior.dart';
import 'package:asadero/componentes/burbuja_asistente.dart';
import 'package:asadero/componentes/tarjeta_pedido.dart';
import 'package:asadero/componentes/detalle_pedido.dart';
import 'package:asadero/services/pedido_service.dart';
import 'package:asadero/pantallas/home.dart';
import 'package:asadero/pantallas/perfil.dart';
import 'package:asadero/pantallas/carrito.dart';
import 'package:asadero/pantallas/productos.dart';
import 'package:asadero/pantallas/pagar_pedido.dart';

class Historial extends StatefulWidget {
  const Historial({super.key});

  @override
  State<Historial> createState() => _HistorialState();
}

class _HistorialState extends State<Historial> {
  final PedidoService _pedidoService = PedidoService();

  List<Map<String, dynamic>> pedidos = [];
  bool cargando = true;
  bool eliminando = false;
  String? error;

  @override
  void initState() {
    super.initState();
    cargarPedidos();
  }

  Future<void> cargarPedidos() async {
    setState(() {
      cargando = true;
      error = null;
    });

    try {
      final resultado = await _pedidoService.obtenerMisPedidos();

      if (!mounted) return;

      setState(() {
        pedidos = resultado;
        cargando = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        error = 'error_cargar_historial';
        cargando = false;
      });
    }
  }

  String formatearFecha(dynamic fecha) {
    if (fecha == null) return texto('sin_fecha');

    final date = DateTime.tryParse(fecha.toString());

    if (date == null) return texto('sin_fecha');

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String formatearTotal(dynamic valor) {
    final total = double.tryParse(valor.toString()) ?? 0;
    final numero = total.toStringAsFixed(0);

    final formateado = numero.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );

    return '\$$formateado';
  }

  String obtenerProductos(Map<String, dynamic> pedido) {
    final detalles = pedido['detalle_pedido'];

    if (detalles is! List || detalles.isEmpty) {
      return texto('sin_productos');
    }

    return detalles
        .map((detalle) {
          final nombre = detalle['nombre'] ?? texto('producto');
          final cantidad = detalle['cantidad'] ?? 1;

          return '$nombre x$cantidad';
        })
        .join(', ');
  }

  String traducirEstado(String estado) {
    switch (estado) {
      case 'Entregado':
        return texto('estado_entregado');
      case 'Pendiente':
        return texto('estado_pendiente');
      default:
        return estado;
    }
  }

  Map<String, String> convertirPedido(Map<String, dynamic> pedido) {
    final id = pedido['id'];

    return {
      'id': id.toString(),
      'numero': '${texto('pedido')} #$id',
      'fecha': formatearFecha(pedido['fecha_pedido']),
      'productos': obtenerProductos(pedido),
      'total': formatearTotal(pedido['total']),
      'estado': pedido['estado']?.toString() ?? 'Pendiente',
      'estado_pago': pedido['estado_pago']?.toString() ?? '',
      if (pedido['numero_mesa'] != null)
        'mesa': pedido['numero_mesa'].toString(),
    };
  }

  // Se conserva el estado original para las condiciones del backend.
  bool puedePagar(Map<String, String> pedido) {
    final pago = pedido['estado_pago'];
    return pedido['estado'] == 'Entregado' &&
        pago != 'Aprobado' &&
        pago != 'Pendiente';
  }

  Future<void> abrirPago(Map<String, String> pedido) async {
    final enviado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => PagarPedido(
          pedidoId: int.parse(pedido['id']!),
          total: pedido['total']!,
        ),
      ),
    );

    if (enviado == true) await cargarPedidos();
  }

  // Confirmar que se desea limpiar todo el historial.
  Future<void> confirmarEliminarHistorial() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.asphalt,
        title: Text(
          texto('borrar_historial'),
          style: const TextStyle(color: AppColors.goldSand),
        ),
        content: Text(
          texto('confirmar_borrar_historial'),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              texto('cancelar'),
              style: const TextStyle(color: AppColors.goldSand),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              texto('borrar_todo'),
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await eliminarHistorial();
    }
  }

  // Ocultar los pedidos del historial.
  Future<void> eliminarHistorial() async {
    setState(() {
      eliminando = true;
    });

    try {
      await _pedidoService.limpiarHistorial();

      if (!mounted) return;

      setState(() {
        pedidos.clear();
        eliminando = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(texto('historial_eliminado'))));
    } catch (_) {
      if (!mounted) return;

      setState(() {
        eliminando = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(texto('error_borrar_historial'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Idioma.seleccionado,
      builder: (context, idioma, child) {
        return Scaffold(
          backgroundColor: AppColors.goldSand,
          appBar: AppBar(
            backgroundColor: AppColors.asphalt,
            foregroundColor: AppColors.goldSand,
            title: Text(
              texto('historial'),
              style: GoogleFonts.kronaOne(fontSize: 18),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: cargando || eliminando ? null : cargarPedidos,
                icon: const Icon(Icons.refresh),
                tooltip: texto('actualizar'),
              ),
              if (pedidos.isNotEmpty)
                IconButton(
                  onPressed: eliminando || cargando
                      ? null
                      : confirmarEliminarHistorial,
                  icon: eliminando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.goldSand,
                          ),
                        )
                      : const Icon(Icons.delete_outline),
                  tooltip: texto('borrar_historial'),
                ),
            ],
          ),
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.goldSand, AppColors.redPrayerFlag],
              ),
            ),
            child: RefreshIndicator(
              onRefresh: cargarPedidos,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    texto('historial'),
                    style: GoogleFonts.kronaOne(
                      fontSize: 17,
                      color: AppColors.earthBrown,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (cargando)
                    const Padding(
                      padding: EdgeInsets.all(30),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (error != null)
                    Center(
                      child: Column(
                        children: [
                          Text(
                            texto(error!),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.asphalt),
                          ),
                          TextButton(
                            onPressed: cargarPedidos,
                            child: Text(texto('reintentar')),
                          ),
                        ],
                      ),
                    )
                  else if (pedidos.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Center(
                        child: Text(
                          texto('sin_pedidos_historial'),
                          style: const TextStyle(
                            color: AppColors.asphalt,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  else
                    ...pedidos.map((pedidoOriginal) {
                      final pedido = convertirPedido(pedidoOriginal);
                      final producto = pedido['productos']!;
                      final estadoOriginal = pedido['estado']!;
                      final estado = traducirEstado(estadoOriginal);

                      return TarjetaPedido(
                        pedido: pedido,
                        producto: producto,
                        estado: estado,
                        onVerDetalle: () {
                          showDialog(
                            context: context,
                            builder: (_) => DetallePedido(
                              pedido: pedido,
                              producto: producto,
                              estado: estado,
                            ),
                          );
                        },
                        onPagar: puedePagar(pedido)
                            ? () => abrirPago(pedido)
                            : null,
                      );
                    }),
                ],
              ),
            ),
          ),
          floatingActionButton: const BurbujaAsistente(),
          bottomNavigationBar: BarraNavegacionInferior(
            indiceActual: 3,
            onTap: (indice) {
              if (indice == 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Home()),
                );
              } else if (indice == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Perfil()),
                );
              } else if (indice == 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Productos()),
                );
              } else if (indice == 4) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Carrito()),
                );
              }
            },
          ),
        );
      },
    );
  }
}
