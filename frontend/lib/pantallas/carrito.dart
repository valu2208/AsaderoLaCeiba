import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/carrito_estado.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/services/pedido_service.dart';
import 'package:asadero/services/user_service.dart';

class Carrito extends StatefulWidget {
  const Carrito({super.key});

  @override
  State<Carrito> createState() => _CarritoState();
}

class _CarritoState extends State<Carrito> {
  bool _enviandoPedido = false;
  bool _esAdmin = false;
  bool _verificandoRol = true;

  String _metodoPago = 'presencial';

  XFile? _comprobante;
  int? _pedidoPendienteComprobanteId;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _verificarRol();
  }

  Future<void> _verificarRol() async {
    final rol = await UserService.getRol();

    if (!mounted) return;

    setState(() {
      _esAdmin = rol.toLowerCase() == 'admin';
      _verificandoRol = false;
    });
  }

  String nombreProducto(CarritoItem item) {
    final idioma = Idioma.seleccionado.value;

    if (idioma == 'English' &&
        item.nombreEn != null &&
        item.nombreEn!.isNotEmpty) {
      return item.nombreEn!;
    }

    if (idioma == 'Português' &&
        item.nombrePt != null &&
        item.nombrePt!.isNotEmpty) {
      return item.nombrePt!;
    }

    return item.nombre;
  }

  void _mostrarMensaje(String mensaje, {bool error = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: error ? AppColors.redPrayerFlag : Colors.green,
      ),
    );
  }

  Future<void> _seleccionarComprobante() async {
    if (_enviandoPedido) return;

    try {
      final imagen = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (imagen == null || !mounted) return;

      setState(() {
        _comprobante = imagen;
      });
    } catch (e) {
      _mostrarMensaje(texto('error_seleccionar_imagen'), error: true);
    }
  }

  Future<void> _realizarPedido() async {
    if (_enviandoPedido || _esAdmin || _verificandoRol) return;

    final items = List<CarritoItem>.from(CarritoEstado.items.value);

    if (items.isEmpty && _pedidoPendienteComprobanteId == null) return;

    if (_metodoPago == 'nequi' && _comprobante == null) {
      _mostrarMensaje(texto('selecciona_comprobante'), error: true);
      return;
    }

    setState(() => _enviandoPedido = true);

    try {
      final servicio = PedidoService();

      if (_pedidoPendienteComprobanteId == null) {
        final pedidoId = await servicio.realizarPedido(
          items,
          metodoPago: _metodoPago,
        );

        if (_metodoPago == 'nequi') {
          _pedidoPendienteComprobanteId = pedidoId;
        } else {
          if (!mounted) return;

          CarritoEstado.vaciar();

          _mostrarMensaje(texto('pedido_registrado'));
          return;
        }
      }

      if (_metodoPago == 'nequi') {
        await servicio.subirComprobante(
          pedidoId: _pedidoPendienteComprobanteId!,
          imagen: _comprobante!,
        );

        if (!mounted) return;

        CarritoEstado.vaciar();

        setState(() {
          _comprobante = null;
          _pedidoPendienteComprobanteId = null;
        });

        _mostrarMensaje(texto('pedido_comprobante_enviado'));
      }
    } catch (e) {
      if (!mounted) return;

      _mostrarMensaje(
        e.toString().replaceFirst('Exception: ', ''),
        error: true,
      );
    } finally {
      if (mounted) {
        setState(() => _enviandoPedido = false);
      }
    }
  }

  Widget _opcionPago({
    required String valor,
    required String titulo,
    required String descripcion,
    required IconData icono,
  }) {
    final seleccionado = _metodoPago == valor;

    return InkWell(
      onTap: _enviandoPedido
          ? null
          : () {
              setState(() {
                _metodoPago = valor;
                if (valor == 'presencial') {
                  _comprobante = null;
                  _pedidoPendienteComprobanteId = null;
                }
              });
            },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.fondoComponentes,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: seleccionado ? AppColors.goldSand : Colors.white24,
            width: seleccionado ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icono, color: AppColors.goldSand, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      color: AppColors.goldSand,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descripcion,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: valor,
              groupValue: _metodoPago,
              activeColor: AppColors.goldSand,
              onChanged: _enviandoPedido
                  ? null
                  : (nuevoValor) {
                      if (nuevoValor != null) {
                        setState(() {
                          _metodoPago = nuevoValor;
                          if (nuevoValor == 'presencial') {
                            _comprobante = null;
                            _pedidoPendienteComprobanteId = null;
                          }
                        });
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }

  Widget _seccionQR() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            texto('instruccion_qr'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              'assets/imagenes/qr_pago.png',
              width: 220,
              height: 220,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return SizedBox(
                  width: 220,
                  height: 220,
                  child: Center(
                    child: Text(
                      texto('qr_no_encontrado'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            texto('instruccion_comprobante'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _enviandoPedido ? null : _seleccionarComprobante,
            icon: const Icon(Icons.image, color: AppColors.goldSand),
            label: Text(
              _comprobante == null
                  ? texto('seleccionar_comprobante')
                  : texto('cambiar_comprobante'),
              style: const TextStyle(color: AppColors.goldSand),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.goldSand),
            ),
          ),
          if (_comprobante != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(_comprobante!.path),
                height: 150,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              texto('comprobante_seleccionado'),
              style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
            ),
          ],
          if (_pedidoPendienteComprobanteId != null) ...[
            const SizedBox(height: 10),
            Text(
              texto('pedido_registrado_reintentar'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.orangeAccent, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _selectorPago() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(top: 10, bottom: 15),
      decoration: BoxDecoration(
        color: AppColors.earthBrown,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            texto('metodo_pago'),
            style: const TextStyle(
              color: AppColors.goldSand,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _opcionPago(
            valor: 'presencial',
            titulo: texto('pago_presencial'),
            descripcion: texto('paga_asadero'),
            icono: Icons.store,
          ),
          _opcionPago(
            valor: 'nequi',
            titulo: texto('pago_qr'),
            descripcion: texto('paga_qr'),
            icono: Icons.qr_code,
          ),
          if (_metodoPago == 'nequi') ...[
            const SizedBox(height: 4),
            _seccionQR(),
          ],
        ],
      ),
    );
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
                      itemCount: items.length + 1,
                      itemBuilder: (context, index) {
                        if (index == items.length) {
                          return _selectorPago();
                        }

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
              bottomNavigationBar: items.isEmpty || _esAdmin || _verificandoRol
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
                                _pedidoPendienteComprobanteId != null
                                    ? texto('reintentar_envio')
                                    : texto('realizar_pedido'),
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
