import 'package:flutter/material.dart';
import 'package:asadero/componentes/visor_imagen.dart';
import 'package:asadero/core/traducciones.dart';

class QrPago extends StatelessWidget {
  const QrPago({super.key});

  static const _ruta = 'assets/imagenes/qr_pago.jpeg';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          texto('instruccion_qr'),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 12),
        FotoAmpliable(
          ruta: _ruta,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              _ruta,
              width: 240,
              height: 240,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => SizedBox(
                width: 240,
                height: 240,
                child: Center(
                  child: Text(
                    texto('qr_no_encontrado'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}