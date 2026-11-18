import 'package:flutter/material.dart';
import 'package:asadero/componentes/carrito_vacio.dart';
import 'package:asadero/componentes/item_carrito.dart';
import 'package:asadero/componentes/nota_pago_final.dart';
import 'package:asadero/componentes/selector_mesa.dart';
import 'package:asadero/core/carrito_estado.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/pantallas/login.dart';
import 'package:asadero/services/pedido_service.dart';
import 'package:asadero/services/user_service.dart';

class Carrito extends StatefulWidget {
  const Carrito({super.key});

  @override
  State<Carrito> createState() => _CarritoState();
}

class _CarritoState extends State<Carrito> {
  bool _enviando = false;
  bool _esAdmin = false;
  bool _verificandoRol = true;

  @override
  void initState() {
    super.initState();
    UserService.getRol().then((rol) {
      if (!mounted) return;
      setState(() {
        _esAdmin = rol.toLowerCase() == 'admin';
        _verificandoRol = false;
      });
    });
  }

  void _mensaje(String texto, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(texto),
      backgroundColor: error ? AppColors.redPrayerFlag : Colors.green,
    ));
  }

  Future<void> _realizarPedido() async {
    if (_enviando || _esAdmin || _verificandoRol) return;
    final items = List<CarritoItem>.from(CarritoEstado.items.value);
    if (items.isEmpty) return;

    final token = await UserService.getToken();
    if (!mounted) return;

    if (token == null || token.isEmpty) {
      _mensaje(texto('login_requerido'), error: true);
      await Navigator.push(
          context, MaterialPageRoute(builder: (_) => const Login()));
      return;
    }

    final mesa = CarritoEstado.mesa.value;
    if (mesa == null) {
      _mensaje(texto('mesa_requerida'), error: true);
      await abrirSelectorMesa(context);
      return;
    }

    setState(() => _enviando = true);
    try {
      await PedidoService().realizarPedido(items, mesa: mesa);
      CarritoEstado.vaciar();
      _mensaje(texto('pedido_registrado'));
    } catch (e) {
      _mensaje(e.toString().replaceFirst('Exception: ', ''), error: true);
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  Widget _botonPedido() {
    return Container(
      padding: const EdgeInsets.all(15),
      color: AppColors.earthBrown,
      child: ElevatedButton(
        onPressed: _enviando ? null : _realizarPedido,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.redPrayerFlag,
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: _enviando
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Idioma.seleccionado,
      builder: (context, idioma, _) => ValueListenableBuilder<List<CarritoItem>>(
        valueListenable: CarritoEstado.items,
        builder: (context, items, _) => Scaffold(
          backgroundColor: AppColors.asphalt,
          appBar: AppBar(
            backgroundColor: AppColors.earthBrown,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.goldSand),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(texto('carrito'),
                style: const TextStyle(color: AppColors.goldSand)),
            centerTitle: true,
          ),
          body: items.isEmpty
              ? const CarritoVacio()
              : ListView(
                  padding: const EdgeInsets.all(15),
                  children: [
                    for (final item in items)
                      ItemCarrito(item: item, bloqueado: _enviando),
                    if (!_esAdmin) ...const [SelectorMesa(), NotaPagoFinal()],
                  ],
                ),
          bottomNavigationBar:
              items.isEmpty || _esAdmin || _verificandoRol ? null : _botonPedido(),
        ),
      ),
    );
  }
}