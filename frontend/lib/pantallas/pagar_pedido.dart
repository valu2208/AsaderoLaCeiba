import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:asadero/componentes/qr_pago.dart';
import 'package:asadero/componentes/selector_comprobante.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/services/pedido_service.dart';

class PagarPedido extends StatefulWidget {
  final int pedidoId;
  final String total;

  const PagarPedido({super.key, required this.pedidoId, required this.total});

  @override
  State<PagarPedido> createState() => _PagarPedidoState();
}

class _PagarPedidoState extends State<PagarPedido> {
  final _picker = ImagePicker();
  XFile? _comprobante;
  bool _enviando = false;

  void _mensaje(String texto, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        backgroundColor: error ? AppColors.redPrayerFlag : Colors.green,
      ),
    );
  }

  Future<void> _elegir() async {
    try {
      final imagen = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (imagen != null && mounted) setState(() => _comprobante = imagen);
    } catch (_) {
      _mensaje(texto('error_seleccionar_imagen'), error: true);
    }
  }

  Future<void> _enviar() async {
    if (_comprobante == null) {
      _mensaje(texto('selecciona_comprobante'), error: true);
      return;
    }

    setState(() => _enviando = true);
    try {
      await PedidoService().subirComprobante(
        pedidoId: widget.pedidoId,
        imagen: _comprobante!,
      );
      if (!mounted) return;
      _mensaje(texto('pedido_comprobante_enviado'));
      Navigator.pop(context, true);
    } catch (_) {
      _mensaje(texto('error_enviar_comprobante'), error: true);
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.asphalt,
      appBar: AppBar(
        backgroundColor: AppColors.earthBrown,
        foregroundColor: AppColors.goldSand,
        title: Text('${texto('pagar_cuenta')} #${widget.pedidoId}'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            '${texto('total')}: ${widget.total}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.goldSand,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const QrPago(),
          const SizedBox(height: 20),
          SelectorComprobante(
            comprobante: _comprobante,
            deshabilitado: _enviando,
            onElegir: _elegir,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _enviando ? null : _enviar,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.redPrayerFlag,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: _enviando
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    texto('enviar_comprobante'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
