import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/fecha_notificacion.dart';
import 'package:asadero/core/tipo_notificacion.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/componentes/resumen_pedido_notificacion.dart';
import 'package:asadero/services/notificaciones_service.dart';

// Ventana pequeña con la notificación completa. Si viene de un pedido, muestra
// los platos con su foto, cantidad y precio, la mesa, el estado y el total.
class DialogoNotificacion extends StatefulWidget {
  final Map<String, dynamic> notificacion;

  const DialogoNotificacion({super.key, required this.notificacion});

  @override
  State<DialogoNotificacion> createState() => _DialogoNotificacionState();
}

class _DialogoNotificacionState extends State<DialogoNotificacion> {
  Future<Map<String, dynamic>?>? _pedido;

  @override
  void initState() {
    super.initState();
    if (widget.notificacion['pedido_id'] != null) {
      _pedido = NotificacionesService.pedidoDe('${widget.notificacion['id']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tipo = TipoNotificacion.de('${widget.notificacion['tipo'] ?? ''}');

    return AlertDialog(
      backgroundColor: AppColors.asphalt,
      title: Row(
        children: [
          Icon(Icons.circle, size: 12, color: tipo.color),
          const SizedBox(width: 8),
          Text(
            texto(tipo.clave),
            style: const TextStyle(color: AppColors.goldSand, fontSize: 15),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${widget.notificacion['titulo'] ?? ''}',
                style: const TextStyle(
                  color: AppColors.goldSand,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.notificacion['mensaje'] ?? ''}',
                style: const TextStyle(color: AppColors.goldSand),
              ),
              const SizedBox(height: 8),
              Text(
                formatearFechaNotificacion(widget.notificacion['creado_en']),
                style: TextStyle(color: AppColors.goldSand.withValues(alpha: 0.7), fontSize: 11),
              ),
              if (_pedido != null)
                FutureBuilder<Map<String, dynamic>?>(
                  future: _pedido,
                  builder: (context, estado) {
                    if (estado.connectionState != ConnectionState.done) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final pedido = estado.data;
                    return pedido == null
                        ? const SizedBox()
                        : ResumenPedidoNotificacion(pedido: pedido);
                  },
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(texto('cerrar'), style: const TextStyle(color: AppColors.goldSand)),
        ),
      ],
    );
  }
}