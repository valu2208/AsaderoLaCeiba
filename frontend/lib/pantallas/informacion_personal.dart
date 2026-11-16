import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/idioma.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/services/user_service.dart';

class InformacionPersonal extends StatefulWidget {
  const InformacionPersonal({super.key});

  @override
  State<InformacionPersonal> createState() => _InformacionPersonalState();
}

class _InformacionPersonalState extends State<InformacionPersonal> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _barrioController = TextEditingController();

  bool _cargando = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();

    _nombreController.text = prefs.getString('user_nombre') ?? '';
    _telefonoController.text = prefs.getString('user_telefono') ?? '';
    _direccionController.text = prefs.getString('user_direccion') ?? '';
    _barrioController.text = prefs.getString('user_barrio') ?? '';

    if (!mounted) return;

    setState(() {
      _cargando = false;
    });
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _guardando = true;
    });

    try {
      await UserService.actualizarPerfil(
        nombre: _nombreController.text.trim(),
        telefono: _telefonoController.text.trim(),
      );

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('user_direccion', _direccionController.text.trim());

      await prefs.setString('user_barrio', _barrioController.text.trim());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(texto('informacion_actualizada')),
          backgroundColor: AppColors.earthBrown,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      final mensaje = e.toString().replaceFirst('Exception: ', '');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje), backgroundColor: AppColors.earthBrown),
      );
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _barrioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Idioma.seleccionado,
      builder: (context, idioma, child) {
        return Scaffold(
          backgroundColor: AppColors.asphalt,
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.goldSand, AppColors.redPrayerFlag],
              ),
            ),
            child: Column(
              children: [
                Container(
                  color: AppColors.asphalt,
                  height: MediaQuery.of(context).padding.top,
                ),
                Expanded(
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(12, 12, 20, 24),
                          decoration: const BoxDecoration(
                            color: AppColors.asphalt,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.goldSand,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  texto('informacion_personal'),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.kronaOne(
                                    color: AppColors.goldSand,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 48),
                            ],
                          ),
                        ),
                        Expanded(
                          child: _cargando
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.goldSand,
                                  ),
                                )
                              : SingleChildScrollView(
                                  padding: const EdgeInsets.all(20),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          texto('editar_datos_cuenta'),
                                          style: GoogleFonts.kronaOne(
                                            color: AppColors.earthBrown,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        _campo(
                                          etiqueta: texto('nombre_completo'),
                                          controller: _nombreController,
                                          icono: Icons.person_outline,
                                          validar: (valor) {
                                            if (valor == null ||
                                                valor.trim().isEmpty) {
                                              return texto('ingresa_nombre');
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 18),
                                        _campo(
                                          etiqueta: texto('telefono'),
                                          controller: _telefonoController,
                                          icono: Icons.phone_outlined,
                                          tipo: TextInputType.phone,
                                          validar: (valor) {
                                            if (valor == null ||
                                                valor.trim().isEmpty) {
                                              return texto('ingresa_telefono');
                                            }

                                            if (valor.trim().length < 7) {
                                              return texto('telefono_valido');
                                            }

                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 18),
                                        _campo(
                                          etiqueta: texto('direccion_opcional'),
                                          controller: _direccionController,
                                          icono: Icons.location_on_outlined,
                                          validar: (valor) => null,
                                        ),
                                        const SizedBox(height: 18),
                                        _campo(
                                          etiqueta: texto('barrio_opcional'),
                                          controller: _barrioController,
                                          icono: Icons.home_outlined,
                                          validar: (valor) => null,
                                        ),
                                        const SizedBox(height: 30),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: _guardando
                                                ? null
                                                : _guardarCambios,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.earthBrown,
                                              foregroundColor:
                                                  AppColors.goldSand,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                            ),
                                            child: _guardando
                                                ? const SizedBox(
                                                    width: 22,
                                                    height: 22,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: AppColors
                                                              .goldSand,
                                                        ),
                                                  )
                                                : Text(
                                                    texto('guardar_cambios'),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _campo({
    required String etiqueta,
    required TextEditingController controller,
    required IconData icono,
    required String? Function(String?) validar,
    TextInputType tipo = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: const TextStyle(
            color: AppColors.earthBrown,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: tipo,
          validator: validar,
          style: const TextStyle(color: AppColors.asphalt),
          decoration: InputDecoration(
            prefixIcon: Icon(icono, color: AppColors.earthBrown),
            filled: true,
            fillColor: AppColors.goldSand,
            errorMaxLines: 2,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.earthBrown),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.earthBrown),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.asphalt, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
