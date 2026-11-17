import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/pantallas/pantalla_manual.dart';

// Botón "Ayuda" que abre el manual de usuario.
// Va al final de los menús laterales (admin, cocinero y mesero).
class BotonAyuda extends StatelessWidget {
  // true cuando está dentro de un Drawer: lo cierra antes de abrir el manual
  final bool cerrarMenu;

  const BotonAyuda({super.key, this.cerrarMenu = true});

  void _abrirManual(BuildContext context) {
    if (cerrarMenu) Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PantallaManual()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.redPrayerFlag.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.help_outline,
            color: AppColors.redPrayerFlag,
          ),
        ),
        title: const Text(
          'Ayuda',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _abrirManual(context),
      ),
    );
  }
}