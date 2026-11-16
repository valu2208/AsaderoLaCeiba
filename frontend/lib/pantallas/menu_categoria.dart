import 'package:flutter/material.dart';
import 'package:asadero/componentes/burbuja_asistente.dart';
import 'package:asadero/componentes/cabecera_categoria.dart';
import 'package:asadero/componentes/carta_productos.dart';
import 'package:asadero/componentes/fondo_degradado.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/dias_semana.dart';
import 'package:asadero/models/opcion_menu.dart';
import 'package:asadero/services/producto_service.dart';

// Platos de una opción del Menú: barra de arriba con la foto y debajo la lista
class MenuCategoria extends StatelessWidget {
  final OpcionMenu opcion;

  const MenuCategoria({super.key, required this.opcion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldSand,
      body: Column(
        children: [
          CabeceraCategoria(opcion: opcion),
          Expanded(
            child: FondoDegradado(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: [
                    CartaProductos(
                      columnas: 1,
                      cargar: () => ProductoService().obtenerPorCategoria(
                        opcion.categoria,
                        dia: opcion.porDia ? diaDeHoy() : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: const BurbujaAsistente(),
    );
  }
}