import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Registrar extends StatefulWidget {
  final Function(Map<String, String>)
  onUserRegistered; // callback para añadir usuario

  const Registrar({super.key, required this.onUserRegistered});

  @override
  _RegistrarState createState() => _RegistrarState();
}

class _RegistrarState extends State<Registrar> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _claveController = TextEditingController();
  final TextEditingController _repiteClaveController = TextEditingController();
  bool _isLoading = false;

  Future<void> _registrar() async {
    setState(() => _isLoading = true);

    final String usuario = _usuarioController.text.trim();
    final String clave = _claveController.text.trim();
    final String repiteClave = _repiteClaveController.text.trim();

    if (usuario.isEmpty || clave.isEmpty || repiteClave.isEmpty) {
      _mostrarDialogo('Campos vacíos', 'Por favor complete todos los campos.');
      setState(() => _isLoading = false);
      return;
    }

    if (clave != repiteClave) {
      _mostrarDialogo('Error', 'Las contraseñas no coinciden');
      setState(() => _isLoading = false);
      return;
    }

    // Simulación de envío a un servicio (original: https://desolate-wave-66962.herokuapp.com/agregar_usuario)
    // Como ese servicio ya no existe, guardamos el usuario en memoria (a través del callback)
    // Además, podríamos intentar conectar a un servicio simulado local, pero para la guía basta con esto.

    // Simulamos éxito después de una pausa
    await Future.delayed(const Duration(seconds: 1));

    // Llamamos al callback para añadir el usuario a la lista en el main
    widget.onUserRegistered({'correo': usuario, 'clave': clave});

    // Mostrar mensaje de éxito y regresar al login
    _mostrarDialogo('Registro exitoso', 'Ahora puede iniciar sesión', true);
  }

  void _mostrarDialogo(
    String titulo,
    String mensaje, [
    bool popAlCerrar = false,
  ]) {
    final screenContext = context; // guardamos el contexto de la pantalla
    showDialog(
      context: screenContext,
      builder: (dialogContext) => AlertDialog(
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // cerrar diálogo
              if (popAlCerrar) {
                Navigator.of(
                  screenContext,
                ).pop(); // cerrar pantalla de registro
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar nuevo usuario')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usuarioController,
              decoration: const InputDecoration(
                hintText: 'Ingrese su correo electrónico',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _claveController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Ingrese su contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _repiteClaveController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Repita su contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _registrar,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Registrar'),
                  ),
          ],
        ),
      ),
    );
  }
}
