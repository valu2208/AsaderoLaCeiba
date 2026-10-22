import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart' show MethodCall, MethodChannel;
import 'package:photo_manager/photo_manager.dart';

// Emulador de Android: al soltar una foto sobre el emulador, este la copia a Descargas.
// Esta clase detecta esa foto nueva y la entrega como archivo (solo se usa en modo debug).
class VigilanteDescargas {
  // Canal nativo definido en MainActivity.kt: fuerza a Android a escanear Descargas
  static const MethodChannel _canal = MethodChannel('asadero/media');

  final void Function(File foto) alRecibirFoto;
  bool _activo = false;
  bool _cerrado = false;
  Timer? _espera; // agrupa los varios avisos que Android manda por una sola foto

  VigilanteDescargas({required this.alRecibirFoto});

  Future<void> iniciar() async {
    try {
      const opcion = PermissionRequestOption(
        androidPermission: AndroidPermission(
          type: RequestType.image,
          mediaLocation: false,
        ),
      );
      // Primero se consulta; solo se pide si aún no está concedido
      var permiso = await PhotoManager.getPermissionState(requestOption: opcion);
      if (!permiso.hasAccess) {
        permiso = await PhotoManager.requestPermissionExtend(requestOption: opcion)
            .timeout(const Duration(seconds: 30), onTimeout: () => PermissionState.denied);
      }
      if (!permiso.hasAccess || _cerrado) return;

      // El permiso ya se verificó arriba; evita que el plugin lo pida en cada consulta
      await PhotoManager.setIgnorePermissionCheck(true);
      PhotoManager.addChangeCallback(_alCambiarGaleria);
      await PhotoManager.startChangeNotify();
      _activo = true;
    } catch (_) {
      // Si algo falla, el selector sigue funcionando con Galería y Cámara
    }
  }

  void detener() {
    _cerrado = true;
    _espera?.cancel();
    if (_activo) {
      PhotoManager.removeChangeCallback(_alCambiarGaleria);
      PhotoManager.stopChangeNotify();
    }
  }

  // Al soltar una foto, el emulador borra y vuelve a crear el archivo en Descargas.
  // Android avisa en medio de ese proceso, así que se espera un momento y se revisa el id.
  void _alCambiarGaleria(MethodCall llamada) {
    final datos = llamada.arguments as Map?;
    final id = datos?['id']?.toString();
    if (id == null || datos?['mediaType'] != 1) return; // 1 = imagen

    _espera?.cancel();
    _espera = Timer(const Duration(milliseconds: 1200), () => _cargarFoto(id));
  }

  Future<void> _cargarFoto(String id) async {
    if (_cerrado) return;

    // En el emulador la foto queda "pendiente" hasta que Android la escanea
    try {
      await _canal.invokeMethod('escanearDescargas');
    } catch (_) {}
    if (_cerrado) return;

    final foto = await AssetEntity.fromId(id);
    if (foto == null || foto.type != AssetType.image) return; // se borró de verdad

    final bytes = await foto.originBytes;
    if (bytes == null || _cerrado) return;

    final archivo = File(
      '${Directory.systemTemp.path}/arrastrada_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await archivo.writeAsBytes(bytes);
    if (!_cerrado) alRecibirFoto(archivo);
  }
}
