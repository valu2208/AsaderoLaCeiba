import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/avatar_usuario.dart';

// Foto (con el lápiz para cambiarla), nombre, correo y rol del perfil del personal
class CabeceraPerfilPersonal extends StatelessWidget {
  final String nombre;
  final String correo;
  final String rol;
  final String? avatar;
  final bool subiendoFoto;
  final VoidCallback onCambiarFoto;

  const CabeceraPerfilPersonal({
    super.key,
    required this.nombre,
    required this.correo,
    required this.rol,
    required this.avatar,
    required this.subiendoFoto,
    required this.onCambiarFoto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      decoration: const BoxDecoration(
        color: AppColors.asphalt,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              AvatarUsuario(url: avatar, radio: 48),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: subiendoFoto ? null : onCambiarFoto,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.goldSand,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.asphalt, width: 2),
                    ),
                    child: subiendoFoto
                        ? const Padding(
                            padding: EdgeInsets.all(7),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.asphalt,
                            ),
                          )
                        : const Icon(Icons.edit, color: AppColors.asphalt, size: 17),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            nombre,
            textAlign: TextAlign.center,
            style: GoogleFonts.kronaOne(color: AppColors.goldSand, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(correo, style: const TextStyle(color: AppColors.goldSand, fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            rol,
            style: TextStyle(color: AppColors.goldSand.withValues(alpha: 0.8), fontSize: 13),
          ),
        ],
      ),
    );
  }
}