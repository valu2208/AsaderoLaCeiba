import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';

// Círculo con la foto del usuario; si no tiene foto (o no carga) muestra un ícono
class AvatarUsuario extends StatelessWidget {
  final String? url;
  final double radio;
  final IconData icono;

  const AvatarUsuario({
    super.key,
    required this.url,
    this.radio = 36,
    this.icono = Icons.person,
  });

  Widget _icono() {
    return SizedBox(
      width: radio * 2,
      height: radio * 2,
      child: Icon(icono, color: AppColors.redPrayerFlag, size: radio),
    );
  }

  @override
  Widget build(BuildContext context) {
    final conFoto = url != null && url!.isNotEmpty;

    return CircleAvatar(
      radius: radio,
      backgroundColor: AppColors.goldSand,
      child: ClipOval(
        child: conFoto
            ? Image.network(
                url!,
                width: radio * 2,
                height: radio * 2,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _icono(),
              )
            : _icono(),
      ),
    );
  }
}