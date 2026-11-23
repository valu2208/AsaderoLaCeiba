import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:asadero/core/colores.dart';

// Seis casillas para escribir el código de verificación.
// Un TextField invisible recibe lo que se teclea y las casillas lo muestran.
class CasillasCodigo extends StatefulWidget {
  final TextEditingController controller;
  final double alto;

  const CasillasCodigo({super.key, required this.controller, this.alto = 65});

  @override
  State<CasillasCodigo> createState() => _CasillasCodigoState();
}

class _CasillasCodigoState extends State<CasillasCodigo>
    with WidgetsBindingObserver {
  final foco = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.controller.addListener(_refrescar);
    foco.addListener(_refrescar);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.controller.removeListener(_refrescar);
    foco.dispose();
    super.dispose();
  }

  void _refrescar() {
    if (mounted) setState(() {});
  }

  // Al volver de otra app o de la barra de notificaciones, el teclado pierde
  // la conexión con el campo aunque Flutter crea que sigue enfocado.
  @override
  void didChangeAppLifecycleState(AppLifecycleState estado) {
    if (estado == AppLifecycleState.resumed) _enfocar();
  }

  // Suelta el foco y lo pide de nuevo para reconectar el teclado.
  void _enfocar() {
    foco.unfocus();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      foco.requestFocus();
      SystemChannels.textInput.invokeMethod('TextInput.show');
    });
  }

  Widget _casilla(int index, List<String> digitos) {
    final activa = foco.hasFocus && index == digitos.length.clamp(0, 5);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _enfocar,
      child: Container(
        width: 45,
        height: widget.alto,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.goldSand,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: activa ? AppColors.redPrayerFlag : AppColors.earthBrown,
            width: activa ? 2 : 1,
          ),
        ),
        child: Text(
          index < digitos.length ? digitos[index] : '',
          style: const TextStyle(
            color: AppColors.asphalt,
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final digitos = widget.controller.text.split('');

    return SizedBox(
      height: widget.alto,
      child: Stack(
        children: [
          Positioned.fill(
            child: TextField(
              controller: widget.controller,
              focusNode: foco,
              autofocus: true,
              enableInteractiveSelection: false,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              style: const TextStyle(color: Colors.transparent, fontSize: 1),
              cursorColor: Colors.transparent,
              showCursor: false,
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isCollapsed: true,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (i) => _casilla(i, digitos)),
          ),
        ],
      ),
    );
  }
}