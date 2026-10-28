
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/services/user_service.dart';

class InformacionPersonal extends StatefulWidget {
  const InformacionPersonal({super.key});

  @override
  State<InformacionPersonal> createState() => _InformacionPersonalState();
}

class _InformacionPersonalState extends State<InformacionPersonal> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();

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
    _correoController.text = prefs.getString('user_email') ?? '';
    _telefonoController.text = prefs.getString('user_telefono') ?? '';

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
        email: _correoController.text.trim(),
        telefono: _telefonoController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Información personal actualizada correctamente'),
          backgroundColor: AppColors.earthBrown,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      final mensaje = e.toString().replaceFirst('Exception: ', '');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
          backgroundColor: AppColors.earthBrown,
        ),
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
    _correoController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                              'Información personal',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Edita los datos de tu cuenta',
                                      style: GoogleFonts.kronaOne(
                                        color: AppColors.earthBrown,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    _campo(
                                      etiqueta: 'Nombre completo',
                                      controller: _nombreController,
                                      icono: Icons.person_outline,
                                      validar: (valor) {
                                        if (valor == null ||
                                            valor.trim().isEmpty) {
                                          return 'Ingresa tu nombre';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 18),
                                    _campo(
                                      etiqueta: 'Correo electrónico',
                                      controller: _correoController,
                                      icono: Icons.email_outlined,
                                      tipo: TextInputType.emailAddress,
                                      validar: (valor) {
                                        final correo = valor?.trim() ?? '';

                                        if (correo.isEmpty) {
                                          return 'Ingresa tu correo electrónico';
                                        }

                                        if (!RegExp(
                                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                        ).hasMatch(correo)) {
                                          return 'Ingresa un correo válido';
                                        }

                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 18),
                                    _campo(
                                      etiqueta: 'Teléfono',
                                      controller: _telefonoController,
                                      icono: Icons.phone_outlined,
                                      tipo: TextInputType.phone,
                                      validar: (valor) {
                                        if (valor == null ||
                                            valor.trim().isEmpty) {
                                          return 'Ingresa tu teléfono';
                                        }

                                        if (valor.trim().length < 7) {
                                          return 'Ingresa un teléfono válido';
                                        }

                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 30),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed:
                                            _guardando ? null : _guardarCambios,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.earthBrown,
                                          foregroundColor: AppColors.goldSand,
                                          padding: const EdgeInsets.symmetric(
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
                                                  color: AppColors.goldSand,
                                                ),
                                              )
                                            : const Text(
                                                'Guardar cambios',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
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
              borderSide: const BorderSide(
                color: AppColors.asphalt,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
