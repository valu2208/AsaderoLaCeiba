import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:asadero/core/colores.dart';
import '../models/ingrediente.dart';

// Datos que devuelve el formulario
class DatosIngrediente {
  final String nombre;
  final String unidad;
  final int stockActual;
  final int stockMinimo;

  const DatosIngrediente({
    required this.nombre,
    required this.unidad,
    required this.stockActual,
    required this.stockMinimo,
  });
}

const _unidades = ['Kg', 'Libras', 'Bulto', 'Litros', 'Unidades'];

InputDecoration _decoracion(String etiqueta) {
  return InputDecoration(
    labelText: etiqueta,
    labelStyle: const TextStyle(color: AppColors.goldSand),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.goldSand),
    ),
  );
}

Widget _campo(TextEditingController controlador, String etiqueta, {bool numero = false}) {
  return TextField(
    controller: controlador,
    keyboardType: numero ? TextInputType.number : TextInputType.text,
    textCapitalization: numero ? TextCapitalization.none : TextCapitalization.sentences,
    inputFormatters: numero ? [FilteringTextInputFormatter.digitsOnly] : null,
    style: const TextStyle(color: AppColors.goldSand),
    decoration: _decoracion(etiqueta),
  );
}

// Formulario para crear (ingrediente null) o editar un ingrediente.
// Al editar no se pide el stock: ese se ajusta con pedirStock.
// Devuelve null si se cancela.
Future<DatosIngrediente?> pedirIngrediente(
  BuildContext context, {
  Ingrediente? ingrediente,
}) {
  final editando = ingrediente != null;
  final nombre = TextEditingController(text: ingrediente?.nombre ?? '');
  final stock = TextEditingController(text: '0');
  final minimo = TextEditingController(text: '${ingrediente?.stockMinimo ?? 0}');

  final opciones = [..._unidades];
  if (editando && !opciones.contains(ingrediente.unidad)) {
    opciones.add(ingrediente.unidad);
  }
  String unidad = editando ? ingrediente.unidad : opciones.first;

  return showDialog<DatosIngrediente>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        backgroundColor: AppColors.asphalt,
        title: Text(
          editando ? 'Editar ingrediente' : 'Nuevo ingrediente',
          style: const TextStyle(color: AppColors.goldSand),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _campo(nombre, 'Nombre'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: unidad,
                dropdownColor: AppColors.asphalt,
                style: const TextStyle(color: AppColors.goldSand),
                decoration: _decoracion('Unidad de medida'),
                items: opciones
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (valor) => setState(() => unidad = valor ?? unidad),
              ),
              const SizedBox(height: 8),
              if (!editando) ...[
                _campo(stock, 'Cantidad disponible', numero: true),
                const SizedBox(height: 8),
              ],
              _campo(minimo, 'Stock mínimo', numero: true),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.goldSand)),
          ),
          TextButton(
            onPressed: () {
              final texto = nombre.text.trim();
              if (texto.isEmpty) return;
              Navigator.pop(
                context,
                DatosIngrediente(
                  nombre: texto,
                  unidad: unidad,
                  stockActual: int.tryParse(stock.text.trim()) ?? 0,
                  stockMinimo: int.tryParse(minimo.text.trim()) ?? 0,
                ),
              );
            },
            child: const Text('Guardar', style: TextStyle(color: AppColors.redPrayerFlag)),
          ),
        ],
      ),
    ),
  );
}