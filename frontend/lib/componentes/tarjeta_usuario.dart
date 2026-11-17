import 'package:flutter/material.dart';
import 'package:asadero/componentes/tarjeta_vidrio.dart';
import 'package:asadero/core/roles.dart';
import 'package:asadero/models/user_model.dart';

// Una fila de la lista de usuarios; al tocar la etiqueta se elige el nuevo rol
class TarjetaUsuario extends StatelessWidget {
  final UserModel usuario;
  final bool esYo; // la cuenta del admin que tiene la sesión abierta
  final ValueChanged<String> onCambiarRol;

  const TarjetaUsuario({
    super.key,
    required this.usuario,
    required this.esYo,
    required this.onCambiarRol,
  });

  // Color de cada rol: oscuro, para que el texto blanco se lea encima
  Color get _color {
    switch (usuario.rol.toLowerCase()) {
      case 'admin':
        return const Color(0xFFB81202);
      case 'mesero':
        return const Color(0xFF1565C0);
      case 'cocinero':
        return const Color(0xFF2E7D32);
      default:
        return const Color(0xFF616161);
    }
  }

  // Etiqueta del rol: pastilla rellena con texto blanco
  Widget _etiqueta({required bool conFlecha}) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 4, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            nombreRol(usuario.rol),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (conFlecha) const Icon(Icons.arrow_drop_down, color: Colors.white),
          if (!conFlecha) const SizedBox(width: 8),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inicial =
        usuario.nombre.isNotEmpty ? usuario.nombre[0].toUpperCase() : '?';

    return TarjetaVidrio(
      claro: true,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _color,
          child: Text(
            inicial,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          esYo ? '${usuario.nombre} (tú)' : usuario.nombre,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: TarjetaVidrio.colorTextoOscuro,
          ),
        ),
        subtitle: Text(
          usuario.email,
          style: TextStyle(color: TarjetaVidrio.colorTextoOscuroSuave),
        ),
        trailing: esYo
            ? _etiqueta(conFlecha: false)
            : PopupMenuButton<String>(
                tooltip: 'Cambiar rol',
                onSelected: onCambiarRol,
                itemBuilder: (context) => rolesSistema
                    .where((rol) => rol != usuario.rol.toLowerCase())
                    .map((rol) => PopupMenuItem(
                          value: rol,
                          child: Text('Cambiar a ${nombreRol(rol)}'),
                        ))
                    .toList(),
                child: _etiqueta(conFlecha: true),
              ),
      ),
    );
  }
}