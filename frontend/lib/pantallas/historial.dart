import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/barra_nav_inferior.dart';
import 'package:asadero/componentes/burbuja_asistente.dart';
import 'package:asadero/pantallas/home.dart';
import 'package:asadero/pantallas/carrito.dart';
import 'package:asadero/pantallas/productos.dart';

class Historial extends StatelessWidget {
  const Historial({super.key});

  final List<Map<String, String>> pedidos = const [
    {
      'numero': 'Pedido #001',
      'fecha': '10 de octubre de 2026',
      'productos': 'Pollo asado completo x1',
      'total': '\$35.000',
      'estado': 'Entregado',
    },
    {
      'numero': 'Pedido #002',
      'fecha': '8 de octubre de 2026',
      'productos': 'Medio pollo asado x1',
      'total': '\$20.000',
      'estado': 'Entregado',
    },
    {
      'numero': 'Pedido #003',
      'fecha': '6 de octubre de 2026',
      'productos': 'Un cuarto de pollo x2',
      'total': '\$24.000',
      'estado': 'Cancelado',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldSand,
      appBar: AppBar(
        backgroundColor: AppColors.asphalt,
        foregroundColor: AppColors.goldSand,
        title: Text('Mi historial', style: GoogleFonts.kronaOne(fontSize: 18)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.goldSand, AppColors.redPrayerFlag],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Mis pedidos anteriores',
              style: GoogleFonts.kronaOne(
                fontSize: 17,
                color: AppColors.earthBrown,
              ),
            ),
            const SizedBox(height: 16),
            ...pedidos.map((pedido) {
              return _tarjetaPedido(context, pedido);
            }),
          ],
        ),
      ),
      floatingActionButton: const BurbujaAsistente(),
      bottomNavigationBar: BarraNavegacionInferior(
        indiceActual: 3,
        onTap: (indice) {
          if (indice == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          } else if (indice == 21) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Productos()),
            );
          } else if (indice == 3) {
            return;
          } else if (indice == 4) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Carrito()),
            );
          }
        },
      ),
    );
  }

  Widget _tarjetaPedido(BuildContext context, Map<String, String> pedido) {
    final estado = pedido['estado']!;

    return Card(
      color: AppColors.asphalt,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    pedido['numero']!,
                    style: const TextStyle(
                      color: AppColors.goldSand,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  estado,
                  style: TextStyle(
                    color: estado == 'Entregado'
                        ? Colors.greenAccent
                        : Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              pedido['fecha']!,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              pedido['productos']!,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Total: ${pedido['total']}',
              style: const TextStyle(
                color: AppColors.goldSand,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _mostrarDetalle(context, pedido),
                child: const Text(
                  'Ver detalle',
                  style: TextStyle(color: AppColors.goldSand),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDetalle(BuildContext context, Map<String, String> pedido) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.asphalt,
          title: Text(
            pedido['numero']!,
            style: const TextStyle(color: AppColors.goldSand),
          ),
          content: Text(
            'Fecha: ${pedido['fecha']}\n\n'
            'Productos: ${pedido['productos']}\n\n'
            'Total: ${pedido['total']}\n\n'
            'Estado: ${pedido['estado']}',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cerrar',
                style: TextStyle(color: AppColors.goldSand),
              ),
            ),
          ],
        );
      },
    );
  }
}
