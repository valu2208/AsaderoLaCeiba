import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/core/traducciones.dart';
import 'package:asadero/core/navegacion_rol.dart';
import 'package:asadero/models/user_model.dart';
import 'package:asadero/services/user_service.dart';
import 'package:asadero/services/google_auth_service.dart';
import 'package:asadero/componentes/barra_navegacion.dart';
import 'package:asadero/componentes/campo_texto.dart';
import 'package:asadero/componentes/boton_principal.dart';
import 'package:asadero/componentes/fila_recordar.dart';
import 'package:asadero/componentes/separador_continuar.dart';
import 'package:asadero/pantallas/recuperar_contrasena.dart';
import 'package:asadero/pantallas/registro.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  bool mostrar = false;
  bool recordar = false;
  bool cargando = false;

  @override
  void dispose() {
    nombreController.dispose();
    correoController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  void _mensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto), backgroundColor: AppColors.redPrayerFlag),
    );
  }
  Future<void> _entrar(Future<UserModel> Function() autenticar) async {
    if (cargando) return;
    setState(() => cargando = true);
    try {
      final usuario = await autenticar();
      if (!mounted) return;
      irSegunRol(context, usuario.rol);
    } catch (e) {
      if (mounted) _mensaje(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  void iniciarSesion() {
    final correo = correoController.text.trim();
    final clave = contrasenaController.text;
    if (correo.isEmpty || clave.isEmpty) {
      return _mensaje('Ingresa tu correo y contraseña');
    }
    _entrar(() => UserService.loginUsuario(correo, clave));
  }

  void iniciarSesionGoogle() {
    _entrar(() async {
      final idToken = await GoogleAuthService.obtenerIdToken();
      return UserService.loginGoogle(idToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.asphalt,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const BarraNavegacion(),
                        const SizedBox(height: 20),
                        const Icon(
                          Icons.account_circle,
                          color: AppColors.goldSand,
                          size: 100,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          texto('iniciar_sesion_titulo'),
                          style: GoogleFonts.kronaOne(
                            color: AppColors.goldSand,
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(height: 30),
                        CampoTexto(
                          texto: texto('nombre'),
                          icono: Icons.person,
                          controller: nombreController,
                        ),
                        const SizedBox(height: 20),
                        CampoTexto(
                          texto: texto('correo_electronico'),
                          icono: Icons.email,
                          teclado: TextInputType.emailAddress,
                          controller: correoController,
                        ),
                        const SizedBox(height: 20),
                        CampoTexto(
                          texto: texto('contrasena'),
                          icono: Icons.lock,
                          ocultar: !mostrar,
                          onPressed: () => setState(() => mostrar = !mostrar),
                          controller: contrasenaController,
                        ),
                        FilaRecordar(
                          recordar: recordar,
                          onCambio: (v) => setState(() => recordar = v),
                          onOlvido: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RecuperarContrasena(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        BotonPrincipal(
                          texto: cargando
                              ? '...'
                              : texto('iniciar_sesion_titulo'),
                          onPressed: iniciarSesion,
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Registro()),
                          ),
                          child: Text(
                            texto('no_tienes_cuenta'),
                            style: const TextStyle(
                              color: AppColors.goldSand,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(height: 20),
                        const SeparadorContinuar(),
                        IconButton(
                          onPressed: iniciarSesionGoogle,
                          icon: const Icon(
                            Icons.g_mobiledata,
                            color: AppColors.goldSand,
                            size: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
