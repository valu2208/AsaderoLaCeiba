import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/componentes/burbuja_mensaje.dart';
import 'package:asadero/componentes/encabezado_chat.dart';
import 'package:asadero/componentes/campo_mensaje.dart';
import 'package:asadero/componentes/indicador_escribiendo.dart';
import 'package:asadero/services/chat_service.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final List<Map<String, String>> _mensajes;

  bool _cargando = false;
  String? _sesionId;

  String _saludo() {
    switch (Idioma.seleccionado.value) {
      case 'English':
        return 'Hello! It is a pleasure to assist you. How can I help you today?';
      case 'Português':
        return 'Olá! É um prazer atender você. Como posso ajudar hoje?';
      default:
        return '¡Hola! Un gusto atenderte. ¿En qué puedo ayudarte hoy?';
    }
  }

  @override
  void initState() {
    super.initState();

    _mensajes = [
      {'role': 'bot', 'text': _saludo()},
    ];

    Idioma.seleccionado.addListener(_actualizarSaludo);
  }

  void _actualizarSaludo() {
    if (!mounted || _mensajes.length != 1) return;

    setState(() {
      _mensajes[0]['text'] = _saludo();
    });
  }

  void _enviarMensaje() async {
    final texto = _controller.text.trim();

    if (texto.isEmpty || _cargando) return;

    _controller.clear();

    setState(() {
      _mensajes.add({'role': 'user', 'text': texto});
      _cargando = true;
    });

    _scrollHaciaAbajo();

    final respuesta = await ChatService.enviarMensaje(
      texto,
      sesionId: _sesionId,
      idioma: Idioma.seleccionado.value,
    );

    if (!mounted) return;

    setState(() {
      _sesionId = respuesta.sesionId ?? _sesionId;

      _mensajes.add({'role': 'bot', 'text': respuesta.texto});

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
    Idioma.seleccionado.removeListener(_actualizarSaludo);
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                  icon: const Icon(Icons.close, color: AppColors.goldSand),
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
            if (_cargando) const IndicadorEscribiendo(),
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
