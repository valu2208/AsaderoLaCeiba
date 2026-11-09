import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import '../models/ingrediente.dart';
import 'tarjeta_ingrediente.dart';

// Lista de ingredientes: ordena (bajos primero), filtra y maneja carga/error/vacío
class ListaIngredientes extends StatelessWidget {
  final Future<List<Ingrediente>> ingredientes;
  final String filtro; // 'todos', 'bajos' o 'ok'
  final String mensajeVacio;
  final Future<void> Function() onRefrescar;
  final void Function(Ingrediente) onTap;

  const ListaIngredientes({
    super.key,
    required this.ingredientes,
    required this.mensajeVacio,
    required this.onRefrescar,
    required this.onTap,
    this.filtro = 'todos',
  });

  Widget _mensaje(String texto) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            texto,
            textAlign: TextAlign.center,
            style: GoogleFonts.josefinSans(color: AppColors.earthBrown, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _contenido(AsyncSnapshot<List<Ingrediente>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator(color: AppColors.earthBrown));
    }
    if (snapshot.hasError) {
      return _mensaje(snapshot.error.toString().replaceAll('Exception: ', ''));
    }

    final todos = [...?snapshot.data];
    if (todos.isEmpty) return _mensaje(mensajeVacio);

    todos.sort((a, b) {
      if (a.bajo != b.bajo) return a.bajo ? -1 : 1;
      return a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase());
    });
    final lista = todos
        .where((i) => filtro == 'todos' || (filtro == 'bajos') == i.bajo)
        .toList();
    if (lista.isEmpty) return _mensaje('No hay ingredientes en esta categoría.');

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 8, bottom: 90),
      itemCount: lista.length,
      itemBuilder: (context, indice) => TarjetaIngrediente(
        ingrediente: lista[indice],
        onTap: () => onTap(lista[indice]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.earthBrown,
      onRefresh: onRefrescar,
      child: FutureBuilder<List<Ingrediente>>(
        future: ingredientes,
        builder: (context, snapshot) => _contenido(snapshot),
      ),
    );
  }
}