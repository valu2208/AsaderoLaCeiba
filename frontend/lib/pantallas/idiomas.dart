import 'package:flutter/material.dart';
import 'package:asadero/core/idioma.dart';

class Idiomas extends StatefulWidget {
  const Idiomas({super.key});

  @override
  State<Idiomas> createState() => _IdiomasState();
}

class _IdiomasState extends State<Idiomas> {
  String? idiomaSeleccionado;

  final List<Map<String, String>> idiomas = [
    {
      'bandera': '🇨🇴',
      'nombre': 'Español',
    },
    {
      'bandera': '🇺🇸',
      'nombre': 'English',
    },
    {
      'bandera': '🇧🇷',
      'nombre': 'Português',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona tu idioma'),
      ),
      body: ListView.builder(
        itemCount: idiomas.length,
        itemBuilder: (context, index) {
          final idioma = idiomas[index]['nombre']!;

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
            trailing: idiomaSeleccionado == idioma
                ? const Icon(Icons.check)
                : null,
            onTap: () {
              setState(() {
                idiomaSeleccionado = idioma;
                Idioma.seleccionado= idioma;
              });
              Navigator.pop( context);
            },
          );
        },
      ),
    );
  }
}