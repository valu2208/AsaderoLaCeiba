import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/services/chat_service.dart';
import 'package:asadero/pantallas/chat.dart';

class HistorialChat extends StatefulWidget {
  const HistorialChat({super.key});

  @override
  State<HistorialChat> createState() => _HistorialChatState();
}

class _HistorialChatState extends State<HistorialChat> {
  List<ConversacionChat> _conversaciones = [];
  bool _cargando = true;
  String? _error;
  final Set<String> _eliminando = {};

  @override
  void initState() {
    super.initState();
    _cargarHistorial();
  }

  Future<void> _cargarHistorial() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final resultado = await ChatService.obtenerHistorial();

      if (!mounted) return;

      setState(() {
        _conversaciones = resultado;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _cargando = false;
      });
    }
  }

  Future<void> _nuevaConversacion() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.asphalt,
      builder: (_) => const Chat(),
    );

    if (mounted) {
      _cargarHistorial();
    }
  }

  // Confirmar y eliminar una conversación.
  Future<void> _eliminarConversacion(ConversacionChat conversacion) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.earthBrown,
        title: const Text(
          'Eliminar conversación',
          style: TextStyle(
            color: AppColors.goldSand,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          '¿Estás seguro de que deseas eliminar esta conversación? '
          'No podrás recuperar sus mensajes.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.goldSand),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: AppColors.redPrayerFlag),
            ),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    setState(() {
      _eliminando.add(conversacion.sesionId);
    });

    try {
      await ChatService.eliminarConversacion(conversacion.sesionId);

      if (!mounted) return;

      setState(() {
        _conversaciones.removeWhere(
          (item) => item.sesionId == conversacion.sesionId,
        );
        _eliminando.remove(conversacion.sesionId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conversación eliminada correctamente.')),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _eliminando.remove(conversacion.sesionId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  String _formatearFecha(DateTime? fecha) {
    if (fecha == null) return '';

    final local = fecha.toLocal();
    final dia = local.day.toString().padLeft(2, '0');
    final mes = local.month.toString().padLeft(2, '0');
    final hora = local.hour.toString().padLeft(2, '0');
    final minuto = local.minute.toString().padLeft(2, '0');

    return '$dia/$mes/${local.year} · $hora:$minuto';
  }

  Future<void> _abrirConversacion(ConversacionChat conversacion) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleHistorialChat(conversacion: conversacion),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.asphalt,
      appBar: AppBar(
        backgroundColor: AppColors.asphalt,
        foregroundColor: AppColors.goldSand,
        elevation: 0,
        title: const Text(
          'Historial del chat',
          style: TextStyle(
            color: AppColors.goldSand,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.redPrayerFlag,
        foregroundColor: Colors.white,
        onPressed: _nuevaConversacion,
        child: const Icon(Icons.add_comment_outlined),
      ),
      body: RefreshIndicator(
        color: AppColors.goldSand,
        backgroundColor: AppColors.earthBrown,
        onRefresh: _cargarHistorial,
        child: _construirContenido(),
      ),
    );
  }

  Widget _construirContenido() {
    if (_cargando) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.goldSand),
      );
    }

    if (_error != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          const Icon(Icons.error_outline, color: AppColors.goldSand, size: 45),
          const SizedBox(height: 12),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: _cargarHistorial,
              child: const Text(
                'Volver a intentar',
                style: TextStyle(color: AppColors.goldSand),
              ),
            ),
          ),
        ],
      );
    }

    if (_conversaciones.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 130),
          Icon(Icons.chat_bubble_outline, color: AppColors.goldSand, size: 55),
          SizedBox(height: 16),
          Center(
            child: Text(
              'Todavía no tienes conversaciones.',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              'Inicia un chat para que aparezca aquí.',
              style: TextStyle(color: AppColors.goldSand, fontSize: 12),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      itemCount: _conversaciones.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final conversacion = _conversaciones[index];
        final eliminando = _eliminando.contains(conversacion.sesionId);

        return Material(
          color: AppColors.earthBrown,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: eliminando ? null : () => _abrirConversacion(conversacion),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.asphalt,
                    child: Icon(
                      Icons.smart_toy_outlined,
                      color: AppColors.goldSand,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          conversacion.titulo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.goldSand,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          conversacion.ultimoMensaje,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _formatearFecha(conversacion.fecha),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  eliminando
                      ? const Padding(
                          padding: EdgeInsets.all(10),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.goldSand,
                            ),
                          ),
                        )
                      : IconButton(
                          tooltip: 'Eliminar conversación',
                          onPressed: () => _eliminarConversacion(conversacion),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.redPrayerFlag,
                          ),
                        ),
                  const Icon(Icons.chevron_right, color: AppColors.goldSand),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DetalleHistorialChat extends StatefulWidget {
  final ConversacionChat conversacion;

  const DetalleHistorialChat({super.key, required this.conversacion});

  @override
  State<DetalleHistorialChat> createState() => _DetalleHistorialChatState();
}

class _DetalleHistorialChatState extends State<DetalleHistorialChat> {
  List<MensajeChat> _mensajes = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarMensajes();
  }

  Future<void> _cargarMensajes() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final resultado = await ChatService.obtenerMensajes(
        widget.conversacion.sesionId,
      );

      if (!mounted) return;

      setState(() {
        _mensajes = resultado;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.asphalt,
      appBar: AppBar(
        backgroundColor: AppColors.asphalt,
        foregroundColor: AppColors.goldSand,
        elevation: 0,
        title: const Text(
          'Conversación',
          style: TextStyle(color: AppColors.goldSand, fontSize: 17),
        ),
      ),
      body: _construirMensajes(),
    );
  }

  Widget _construirMensajes() {
    if (_cargando) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.goldSand),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
              TextButton(
                onPressed: _cargarMensajes,
                child: const Text(
                  'Volver a intentar',
                  style: TextStyle(color: AppColors.goldSand),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_mensajes.isEmpty) {
      return const Center(
        child: Text(
          'Esta conversación no tiene mensajes.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _mensajes.length,
      itemBuilder: (context, index) {
        final mensaje = _mensajes[index];

        return Align(
          alignment: mensaje.esUsuario
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.78,
            ),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: mensaje.esUsuario
                  ? AppColors.redPrayerFlag
                  : AppColors.earthBrown,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              mensaje.mensaje,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        );
      },
    );
  }
}
