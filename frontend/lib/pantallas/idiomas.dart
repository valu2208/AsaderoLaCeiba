import 'package:flutter/material.dart';

import 'package:asadero/core/idioma.dart';
import 'package:asadero/core/traducciones.dart';

class Idiomas extends StatelessWidget {
  const Idiomas({super.key});

  final List<Map<String, String>> idiomas = const [
    {'bandera': '🇨🇴', 'nombre': 'Español'},
    {'bandera': '🇺🇸', 'nombre': 'English'},
    {'bandera': '🇧🇷', 'nombre': 'Português'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(texto('selecciona_idioma'))),
      body: ValueListenableBuilder<String>(
        valueListenable: Idioma.seleccionado,
        builder: (context, seleccionado, child) {
          return ListView.builder(
            itemCount: idiomas.length,
            itemBuilder: (context, index) {
              final idioma = idiomas[index]['nombre']!;

              final estaSeleccionado = seleccionado == idioma;

              return ListTile(
                leading: Text(
                  idiomas[index]['bandera']!,
                  style: const TextStyle(fontSize: 28),
                ),
                title: Text(
                  idioma,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: estaSeleccionado
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
                onTap: () async {
                  await Idioma.cambiar(idioma);

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
