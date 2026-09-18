import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/pantallas/login.dart';
import 'package:asadero/pantallas/registro.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [1.0],
            colors: [
              AppColors.asphalt,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const SizedBox(height: 35),

                const SizedBox(height: 70),

                const Text(
                  'Tu próxima gran idea empieza aqui! 💫',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.goldSand,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Crea tu cuenta en 30 segundos y descubre todo lo que tenemos para ti',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.goldSand, fontSize: 18),
                ),

                const Spacer(),

                // BOTÓN COMENZAR AHORA
                Container(
                  width: double.infinity,
                  height: 60,
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Registro(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Comenzar ahora',
                      style: TextStyle(
                        color: AppColors.goldSand,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // INICIAR SESIÓN
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: AppColors.goldSand, fontSize: 16),
                      children: [
                        TextSpan(text: '¿Ya tiene cuenta? '),
                        TextSpan(
                          text: 'Inicia Sesión',
                          style: TextStyle(
                            color: Color.fromARGB(255, 238, 201, 88),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  '── O Continua Con ──',
                  style: TextStyle(color: AppColors.goldSand, fontSize: 15),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.facebook,
                        color: AppColors.goldSand,
                        size: 32,
                      ),
                    ),

                    const SizedBox(width: 20),

                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.g_mobiledata,
                        color: AppColors.goldSand,
                        size: 38,
                      ),
                    ),

                    const SizedBox(width: 20),

                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.apple,
                        color: AppColors.goldSand,
                        size: 32,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
