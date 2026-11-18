
import 'package:flutter/material.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

import 'package:asadero/core/idioma.dart';
import 'package:asadero/pantallas/bienvenida.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuración del selector de imágenes de Android.
  final ImagePickerPlatform picker = ImagePickerPlatform.instance;

  if (picker is ImagePickerAndroid) {
    picker.useAndroidPhotoPicker = true;
  }

  // Cargar el idioma guardado.
  await Idioma.cargar();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Idioma.seleccionado,
      builder: (context, idioma, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const Bienvenida(),
        );
      },
    );
  }
}
