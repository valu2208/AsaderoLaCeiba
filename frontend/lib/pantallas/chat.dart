import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/burbuja_mensaje.dart';
import 'package:asadero/componentes/encabezado_chat.dart';
import 'package:asadero/componentes/campo_mensaje.dart';
import 'package:asadero/services/chat_service.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _mensajes = [
    {
      'role': 'bot',
      'text': '¡Hola! Un gusto atenderte. ¿En qué puedo ayudarte hoy?',
    },
  ];
  bool _cargando = false;
  String? _sesionId;
    void _enviarMensaje() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty || _cargando) {
      return;
    }
    _controller.clear();
    setState(() {
      _mensajes.add({
        'role': 'user',
        'text': texto,
      });
      _cargando = true;
    });
    _scrollHaciaAbajo();
    final respuesta = await ChatService.enviarMensaje(
      texto,
      sesionId: _sesionId,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _sesionId = respuesta.sesionId ?? _sesionId;
      _mensajes.add({
        'role': 'bot',
        'text': respuesta.texto,
      });
      _cargando = false;
    });
    _scrollHaciaAbajo();
  } 
  void _scrollHaciaAbajo() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.asphalt,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.goldSand,
                  ),
                ),
              ],
            ),
            const EncabezadoChat(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _mensajes.length,
                itemBuilder: (context, index) {
                  final mensaje = _mensajes[index];

                  return BurbujaMensaje(
                    texto: mensaje['text']!,
                    esUsuario: mensaje['role'] == 'user',
                  );
                },
              ),
            ),
            if (_cargando)
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.goldSand,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'El asistente está respondiendo...',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            CampoMensaje(
              controller: _controller,
              cargando: _cargando,
              onEnviar: _enviarMensaje,
            ),
          ],
        ),
      ),
    );
  }
}