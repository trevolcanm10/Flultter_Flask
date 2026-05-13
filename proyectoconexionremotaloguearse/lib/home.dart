import 'package:flutter/material.dart';
import 'NavDrawer.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunidad Conocimiento I+D+I+Sistemas'),
        backgroundColor: Colors.blue,
      ),
      drawer: const NavDrawer(), // Menú lateral
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo (si tienes uno, opcional)
            Image.asset('assets/images/person_icon.png'),
            const SizedBox(height: 20),
            const SizedBox(height: 8),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Acción del botón: por ejemplo, abrir el Drawer
                Scaffold.of(context).openDrawer();
                // O también podrías navegar a otra pantalla
                // Según la guía, al presionar el botón se abre el menú.
              },
              child: const Text('Abrir Menú'),
            ),
          ],
        ),
      ),
    );
  }
}
