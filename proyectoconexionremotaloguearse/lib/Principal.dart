import 'package:flutter/material.dart';
import 'NavDrawer.dart';

class Principal extends StatelessWidget {
  final String usuario;

  const Principal({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Principal'),
        backgroundColor: Colors.blue,
      ),
      drawer: const NavDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            Text(
              'Bienvenido $usuario',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Usa el menú lateral para navegar',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}