import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/pantallas/chat.dart';

class EncabezadoHome extends StatelessWidget {
  const EncabezadoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Idioma.seleccionado,
      builder: (context, idioma, child) {
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
                  _fila(context),
                  const SizedBox(height: 16),
                  _buscador(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _fila(BuildContext context) {
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
            texto('bienvenido_usuario'),
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
        IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: AppColors.asphalt,
              builder: (_) => const Chat(),
            );
          },
          icon: const Icon(
            Icons.chat_bubble_outline,
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
        hintText: texto('buscar'),
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

