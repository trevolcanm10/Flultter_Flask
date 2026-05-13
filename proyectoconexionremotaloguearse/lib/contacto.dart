import 'package:flutter/material.dart';

class ContactoPage extends StatelessWidget {
  const ContactoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacto'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text('Correo: universidad@ejemplo.com\nTeléfono: 123-456-789'),
      ),
    );
  }
}
