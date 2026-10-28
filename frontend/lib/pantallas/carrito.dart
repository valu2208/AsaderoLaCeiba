import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/carrito_estado.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/services/pedido_service.dart';

class Carrito extends StatefulWidget {
  const Carrito({super.key});

  @override
  State<Carrito> createState() => _CarritoState();
}

class _CarritoState extends State<Carrito> {
  bool _enviandoPedido = false;

  String nombreProducto(CarritoItem item) {
    if (item.imagen.contains('pollo_completo')) {
      return texto('pollo_completo');
    }
    if (item.imagen.contains('medio_pollo')) {
      return texto('medio_pollo');
    }
    if (item.imagen.contains('uncuarto_pollo')) {
      return texto('cuarto_pollo');
    }
    return item.nombre;
  }

  Future<void> _realizarPedido() async {
    if (_enviandoPedido) return;

    final items = List<CarritoItem>.from(CarritoEstado.items.value);

    if (items.isEmpty) return;

    setState(() => _enviandoPedido = true);

    try {
      final pedidoId = await PedidoService().realizarPedido(items);

      if (!mounted) return;

      CarritoEstado.vaciar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pedido #$pedidoId registrado correctamente.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: AppColors.redPrayerFlag,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _enviandoPedido = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Idioma.seleccionado,
      builder: (context, idioma, child) {
        return ValueListenableBuilder<List<CarritoItem>>(
          valueListenable: CarritoEstado.items,
          builder: (context, items, child) {
            return Scaffold(
              backgroundColor: AppColors.asphalt,
              appBar: AppBar(
                backgroundColor: AppColors.earthBrown,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.goldSand),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  texto('carrito'),
                  style: const TextStyle(color: AppColors.goldSand),
                ),
                centerTitle: true,
              ),
              body: items.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.shopping_cart_outlined,
                              size: 80,
                              color: AppColors.goldSand,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              texto('carrito_vacio'),
                              style: const TextStyle(
                                color: AppColors.goldSand,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              texto('agrega_favoritos'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return Card(
                          color: AppColors.fondoComponentes,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: item.imagen.startsWith('http')
                                  ? Image.network(
                                      item.imagen,
                                      width: 55,
                                      height: 55,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const SizedBox(
                                              width: 55,
                                              height: 55,
                                              child: Icon(
                                                Icons.restaurant,
                                                color: AppColors.goldSand,
                                              ),
                                            );
                                          },
                                    )
                                  : Image.asset(
                                      item.imagen,
                                      width: 55,
                                      height: 55,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const SizedBox(
                                              width: 55,
                                              height: 55,
                                              child: Icon(
                                                Icons.restaurant,
                                                color: AppColors.goldSand,
                                              ),
                                            );
                                          },
                                    ),
                            ),
                            title: Text(
                              nombreProducto(item),
                              style: const TextStyle(
                                color: AppColors.goldSand,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${item.precio}\n${texto('cantidad')}: ${item.cantidad}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: IconButton(
                              tooltip: texto('eliminar_producto'),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: AppColors.goldSand,
                              ),
                              onPressed: _enviandoPedido
                                  ? null
                                  : () {
                                      CarritoEstado.eliminar(item.nombre);
                                    },
                            ),
                          ),
                        );
                      },
                    ),
              bottomNavigationBar: items.isEmpty
                  ? null
                  : Container(
                      padding: const EdgeInsets.all(15),
                      color: AppColors.earthBrown,
                      child: ElevatedButton(
                        onPressed: _enviandoPedido ? null : _realizarPedido,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.redPrayerFlag,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: _enviandoPedido
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                texto('realizar_pedido'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}
