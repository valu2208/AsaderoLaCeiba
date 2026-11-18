import 'package:flutter/material.dart';
import 'package:asadero/core/carrito_estado.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/limites_pedido.dart';
import 'package:asadero/core/traducciones.dart';

Future<void> abrirSelectorMesa(BuildContext context) async {
  // Si ya hay una mesa elegida, queda bloqueada: no se vuelve a abrir.
  if (CarritoEstado.mesa.value != null) return;
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.asphalt,
    builder: (_) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            texto('mesa_titulo'),
            style: const TextStyle(
              color: AppColors.goldSand,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var n = 1; n <= LimitesPedido.maxMesas; n++)
                ChoiceChip(
                  label: Text('$n'),
                  selected: CarritoEstado.mesa.value == n,
                  selectedColor: AppColors.goldSand,
                  onSelected: (_) {
                    CarritoEstado.mesa.value = n;
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ],
      ),
    ),
  );
}

class SelectorMesa extends StatelessWidget {
  const SelectorMesa({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int?>(
      valueListenable: CarritoEstado.mesa,
      builder: (context, mesa, _) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.earthBrown,
            borderRadius: BorderRadius.circular(12),
          ),
          child: OutlinedButton.icon(
            // Con la mesa elegida el botón queda bloqueado (null = deshabilitado).
            onPressed: mesa == null ? () => abrirSelectorMesa(context) : null,
            icon: Icon(
              mesa == null ? Icons.table_restaurant : Icons.lock,
              color: AppColors.goldSand,
            ),
            label: Text(
              mesa == null ? texto('mesa_boton') : '${texto('mesa')} $mesa',
              style: const TextStyle(color: AppColors.goldSand),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: mesa == null ? Colors.orangeAccent : AppColors.goldSand,
                width: 2,
              ),
            ),
          ),
        );
      },
    );
  }
}
