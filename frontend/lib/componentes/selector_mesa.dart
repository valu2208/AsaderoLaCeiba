import 'package:flutter/material.dart';
import 'package:asadero/core/carrito_estado.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/limites_pedido.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/services/pedido_service.dart';

Future<void> abrirSelectorMesa(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.asphalt,
    builder: (_) => const _PanelMesas(),
  );
}

// Panel con las mesas. Las que ya tienen un pedido salen en rojo y no se pueden elegir.
class _PanelMesas extends StatelessWidget {
  const _PanelMesas();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: FutureBuilder<Set<int>>(
        future: PedidoService().mesasOcupadas(),
        builder: (context, snapshot) {
          final cargando = snapshot.connectionState != ConnectionState.done;
          final ocupadas = snapshot.data ?? <int>{};

          return Column(
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
              const SizedBox(height: 6),
              Text(
                texto('mesa_ocupada_aviso'),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),
              if (cargando)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(color: AppColors.goldSand),
                )
              else
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (var n = 1; n <= LimitesPedido.maxMesas; n++)
                      _fichaMesa(context, n, ocupadas.contains(n)),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _fichaMesa(BuildContext context, int n, bool ocupada) {
    return ChoiceChip(
      label: Text('$n', style: TextStyle(color: ocupada ? Colors.white : null)),
      avatar: ocupada
          ? const Icon(Icons.lock, size: 16, color: Colors.white)
          : null,
      selected: CarritoEstado.mesa.value == n,
      selectedColor: AppColors.goldSand,
      disabledColor: Colors.red.shade800,
      // null = la ficha queda bloqueada y no se puede presionar.
      onSelected: ocupada
          ? null
          : (_) {
              CarritoEstado.mesa.value = n;
              Navigator.pop(context);
            },
    );
  }
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
            onPressed: () => abrirSelectorMesa(context),
            icon: const Icon(Icons.table_restaurant, color: AppColors.goldSand),
            label: Text(
              mesa == null
                  ? texto('mesa_boton')
                  : '${texto('mesa')} $mesa · ${texto('mesa_cambiar')}',
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
