import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';

// Círculo de la foto + saludo "¡Bienvenid@, nombre!"
class FilaUsuarioHome extends StatelessWidget {
  final String nombre;
  final String? avatar;

  const FilaUsuarioHome({super.key, required this.nombre, this.avatar});

  @override
  Widget build(BuildContext context) {
    final conFoto = avatar != null && avatar!.isNotEmpty;

    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.earthBrown,
          backgroundImage: conFoto ? NetworkImage(avatar!) : null,
          child: conFoto
              ? null
              : const Icon(Icons.person, color: AppColors.goldSand, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            nombre.isEmpty
                ? texto('bienvenido_usuario')
                : '¡Bienvenid@, $nombre!',
            style: GoogleFonts.kronaOne(
              color: AppColors.goldSand,
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}