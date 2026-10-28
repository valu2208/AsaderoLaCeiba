import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:asadero/core/colores.dart';
import 'package:asadero/services/api_config.dart';
import 'package:asadero/services/user_service.dart';

class Notificaciones extends StatefulWidget {
  const Notificaciones({super.key});

  @override
  State<Notificaciones> createState() => _NotificacionesState();
}

class _NotificacionesState extends State<Notificaciones> {
  List<Map<String, dynamic>> notificaciones = [];
  bool cargando = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _cargarNotificaciones();
  }

  Future<void> _cargarNotificaciones() async {
    setState(() {
      cargando = true;
      error = null;
    });

    try {
      final token = await UserService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Debes iniciar sesión para ver tus notificaciones.');
      }

      final respuesta = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/notificaciones'),
        headers: {
          ...ApiConfig.headers,
          'Authorization': 'Bearer $token',
        },
      );

      if (respuesta.statusCode != 200) {
        throw Exception('No se pudieron cargar las notificaciones.');
      }

      final List<dynamic> datos = jsonDecode(respuesta.body);

      if (!mounted) return;

      setState(() {
        notificaciones = datos
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString().replaceFirst('Exception: ', '');
        cargando = false;
      });
    }
  }

  Future<void> _marcarComoLeida(Map<String, dynamic> notificacion) async {
    if (notificacion['leida'] == true) return;

    try {
      final token = await UserService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Debes iniciar sesión nuevamente.');
      }

      final respuesta = await http.patch(
        Uri.parse(
          '${ApiConfig.baseUrl}/notificaciones/${notificacion['id']}/leida',
        ),
        headers: {
          ...ApiConfig.headers,
          'Authorization': 'Bearer $token',
        },
      );

      if (respuesta.statusCode != 200) {
        throw Exception('No se pudo marcar la notificación como leída.');
      }

      if (!mounted) return;

      setState(() {
        notificacion['leida'] = true;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
  }

  IconData _obtenerIcono(String tipo) {
    switch (tipo) {
      case 'bienvenida':
        return Icons.restaurant_outlined;
      case 'estado_pedido':
        return Icons.local_dining_outlined;
      case 'pedido':
        return Icons.shopping_bag_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  String _formatearFecha(dynamic fecha) {
    if (fecha == null) return '';

    final date = DateTime.tryParse(fecha.toString());
    if (date == null) return '';

    final local = date.toLocal();
    final ahora = DateTime.now();

    if (local.year == ahora.year &&
        local.month == ahora.month &&
        local.day == ahora.day) {
      return 'Hoy ${local.hour.toString().padLeft(2, '0')}:'
          '${local.minute.toString().padLeft(2, '0')}';
    }

    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/'
        '${local.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldSand,
      appBar: AppBar(
        backgroundColor: AppColors.asphalt,
        foregroundColor: AppColors.goldSand,
        centerTitle: true,
        title: Text(
          'Notificaciones',
          style: GoogleFonts.kronaOne(fontSize: 16),
        ),
        actions: [
          IconButton(
            onPressed: _cargarNotificaciones,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.goldSand,
              AppColors.redPrayerFlag,
            ],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _cargarNotificaciones,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Tus avisos',
                style: GoogleFonts.kronaOne(
                  fontSize: 17,
                  color: AppColors.earthBrown,
                ),
              ),
              const SizedBox(height: 16),
              if (cargando)
                const Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.earthBrown,
                    ),
                  ),
                )
              else if (error != null)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 45,
                        color: AppColors.earthBrown,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.earthBrown,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _cargarNotificaciones,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              else if (notificaciones.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 55,
                        color: AppColors.earthBrown,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No tienes notificaciones todavía.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.earthBrown,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...notificaciones.map((notificacion) {
                  final leida = notificacion['leida'] == true;

                  return Card(
                    color: AppColors.earthBrown,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      onTap: () => _marcarComoLeida(notificacion),
                      contentPadding: const EdgeInsets.all(14),
                      leading: Icon(
                        _obtenerIcono(
                          notificacion['tipo']?.toString() ?? '',
                        ),
                        color: AppColors.goldSand,
                        size: 30,
                      ),
                      title: Text(
                        notificacion['titulo']?.toString() ?? '',
                        style: TextStyle(
                          color: AppColors.goldSand,
                          fontWeight:
                              leida ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notificacion['mensaje']?.toString() ?? '',
                              style: TextStyle(
                                color: AppColors.goldSand.withValues(
                                  alpha: 0.85,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              leida ? 'Leída' : 'Sin leer · Toca para marcar',
                              style: TextStyle(
                                color: AppColors.goldSand.withValues(
                                  alpha: 0.7,
                                ),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Text(
                        _formatearFecha(notificacion['creado_en']),
                        style: const TextStyle(
                          color: AppColors.goldSand,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
