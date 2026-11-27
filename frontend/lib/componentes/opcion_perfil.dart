import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

// Una opción de la pantalla de perfil: tarjeta con ícono, título y subtítulo
class OpcionPerfil extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const OpcionPerfil({
    super.key,
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.earthBrown,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icono, color: AppColors.goldSand, size: 28),
        title: Text(
          titulo,
          style: const TextStyle(
            color: AppColors.goldSand,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitulo,
          style: TextStyle(
            color: AppColors.goldSand.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.goldSand),
        onTap: onTap,
      ),
    );
  }
}