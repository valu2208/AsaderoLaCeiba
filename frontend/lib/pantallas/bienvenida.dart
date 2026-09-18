import 'package:flutter/material.dart';
import 'package:asadero/core/colores.dart';
import 'package:asadero/pantallas/inicio.dart';

class Bienvenida extends StatelessWidget {
  const Bienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0.05, 0.32, 0.46, 0.76, 1.0],
            colors: [
              AppColors.goldSand,
              AppColors.redPrayerFlag,
              AppColors.demonicPresence,
              AppColors.earthBrown,
              AppColors.asphalt,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              ClipOval(
                child: 
              Image.asset(
                'assets/imagenes/logo_ceiba.jpeg',
                width: 309,
                height: 309,
                fit: BoxFit.cover
              ),
              ),
              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Inicio(),
                    ),
                  );
                },
                child: const Text(
                  '¡haz click aquí!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}