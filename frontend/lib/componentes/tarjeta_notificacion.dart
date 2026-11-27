import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/fecha_notificacion.dart';
import 'package:asadero/core/tipo_notificacion.dart';
import 'package:asadero/core/traducciones.dart';

// Una notificación de la lista: punto de color según el tipo, y en negrita si
// todavía no se ha leído. Al tocarla se abre la ventana de detalle.
class TarjetaNotificacion extends StatelessWidget {
  final Map<String, dynamic> notificacion;
  final VoidCallback onTap;

  const TarjetaNotificacion({
    super.key,
    required this.notificacion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final leida = notificacion['leida'] == true;
    final tipo = TipoNotificacion.de('${notificacion['tipo'] ?? ''}');

    return Card(
      color: AppColors.earthBrown,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(14),
        leading: Icon(tipo.icono, color: AppColors.goldSand, size: 30),
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: tipo.color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${notificacion['titulo'] ?? ''}',
                style: TextStyle(
                  color: AppColors.goldSand,
                  fontWeight: leida ? FontWeight.normal : FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${notificacion['mensaje'] ?? ''}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.goldSand.withValues(alpha: 0.85)),
              ),
              const SizedBox(height: 6),
              Text(
                leida ? texto('leida') : texto('sin_leer_tocar'),
                style: TextStyle(
                  color: AppColors.goldSand.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        trailing: Text(
          formatearFechaNotificacion(notificacion['creado_en']),
          style: const TextStyle(color: AppColors.goldSand, fontSize: 11),
        ),
      ),
    );
  }
}