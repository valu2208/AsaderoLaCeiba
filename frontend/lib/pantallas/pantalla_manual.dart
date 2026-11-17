import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:asadero/core/colores.dart';

// Muestra el manual de usuario (PDF guardado en assets)
class PantallaManual extends StatefulWidget {
  const PantallaManual({super.key});

  @override
  State<PantallaManual> createState() => _PantallaManualState();
}

class _PantallaManualState extends State<PantallaManual> {
  static const String _rutaPdf = 'assets/manual/manual_usuario.pdf';

  late final PdfControllerPinch _controlador;

  @override
  void initState() {
    super.initState();
    _controlador = PdfControllerPinch(
      document: PdfDocument.openAsset(_rutaPdf),
    );
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldSand,
      appBar: AppBar(
        title: const Text('Manual de usuario'),
        backgroundColor: AppColors.asphalt,
        foregroundColor: AppColors.goldSand,
      ),
      body: PdfViewPinch(
        controller: _controlador,
        builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
          options: const DefaultBuilderOptions(),
          documentLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          pageLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          errorBuilder: (_, error) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No se pudo abrir el manual.\n$error',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}