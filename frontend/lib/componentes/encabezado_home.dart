import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';

class EncabezadoHome extends StatelessWidget {
  const EncabezadoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.asphalt,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: Column(
            children: [
              _fila(),
              const SizedBox(height: 16),
              _buscador(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fila() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.earthBrown,
          child: Icon(
            Icons.person,
            color: AppColors.goldSand,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Bienvenido, usuario! 👋',
            style: GoogleFonts.kronaOne(
              color: AppColors.goldSand,
              fontSize: 13,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none,
            color: AppColors.goldSand,
          ),
        ),
      ],
    );
  }

  Widget _buscador() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Buscar...',
        hintStyle: TextStyle(
          color: AppColors.goldSand.withValues(alpha: 0.7),
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.redPrayerFlag,
        ),
        filled: true,
        fillColor: AppColors.earthBrown,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}