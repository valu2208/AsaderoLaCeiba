import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/componentes/barra_navegacion.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  bool mostrarContrasena = false;
  bool mostrarConfirmarContrasena = false;

  // Método reutilizable para no repetir el estilo en cada campo
  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return TextField(
      obscureText: isPassword ? obscureText : false,
      style: const TextStyle(
        color: AppColors.goldSand,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: AppColors.goldSand,
        ),
        filled: true,
        fillColor: AppColors.earthBrown,
        prefixIcon: Icon(
          icon,
          size: 29,
          color: AppColors.redPrayerFlag,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.redPrayerFlag,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.goldSand,
            width: 2,
          ),
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: onToggleVisibility,
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.redPrayerFlag,
                ),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [1.0],
            colors: [AppColors.asphalt],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const BarraNavegacion(),
                const SizedBox(height: 30),

                const Text(
                  'Registrate',
                  style: TextStyle(
                    color: AppColors.goldSand,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 35),

                _buildTextField(
                  label: 'Nombre',
                  icon: Icons.person,
                ),

                const SizedBox(height: 18),

                _buildTextField(
                  label: 'Teléfono',
                  icon: Icons.phone,
                ),

                const SizedBox(height: 18),

                _buildTextField(
                  label: 'Correo Electrónico',
                  icon: Icons.email,
                ),

                const SizedBox(height: 18),

                _buildTextField(
                  label: 'Contraseña',
                  icon: Icons.password,
                  isPassword: true,
                  obscureText: !mostrarContrasena,
                  onToggleVisibility: () {
                    setState(() {
                      mostrarContrasena = !mostrarContrasena;
                    });
                  },
                ),

                const SizedBox(height: 18),

                _buildTextField(
                  label: 'Confirmar contraseña',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  obscureText: !mostrarConfirmarContrasena,
                  onToggleVisibility: () {
                    setState(() {
                      mostrarConfirmarContrasena = !mostrarConfirmarContrasena;
                    });
                  },
                ),

                const SizedBox(height: 25),

                // BOTÓN CREAR CUENTA
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [AppColors.redPrayerFlag, AppColors.earthBrown],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(blurRadius: 8, offset: Offset(0, 4)),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Crear cuenta',
                      style: TextStyle(color: AppColors.goldSand, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}