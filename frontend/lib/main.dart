import 'package:flutter/material.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:asadero/pantallas/bienvenida.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Android: usar el Photo Picker moderno, que muestra todas las imágenes del
  // dispositivo (incluidas las de Descargas, donde llegan las fotos arrastradas al emulador)
  final ImagePickerPlatform picker = ImagePickerPlatform.instance;
  if (picker is ImagePickerAndroid) {
    picker.useAndroidPhotoPicker = true;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Bienvenida(),
    );
  }
}