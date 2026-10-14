import 'package:flutter/material.dart';
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

  Widget _etiqueta({required bool conFlecha}) {
    final color = colorRol(usuario.rol);
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 4, top: 4, bottom: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(nombreRol(usuario.rol), style: TextStyle(color: color)),
          if (conFlecha) Icon(Icons.arrow_drop_down, color: color),
          if (!conFlecha) const SizedBox(width: 6),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inicial =
        usuario.nombre.isNotEmpty ? usuario.nombre[0].toUpperCase() : '?';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorRol(usuario.rol),
          child: Text(inicial, style: const TextStyle(color: Colors.white)),
        ),
        title: Text(
          esYo ? '${usuario.nombre} (tú)' : usuario.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(usuario.email),
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