import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'Registrar.dart';
import 'Principal.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App',
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _claveController = TextEditingController();
  bool _isLoading = false;

  // Lista de usuarios (se cargará desde SharedPreferences + JSON inicial)
  List<Map<String, dynamic>> _usuarios = [];

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  // Cargar usuarios: primero desde SharedPreferences, si no hay, desde el JSON de GitHub
  Future<void> _cargarUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    final String? usuariosGuardados = prefs.getString('usuarios');

    if (usuariosGuardados != null) {
      // Si ya hay datos guardados (incluye usuarios registrados), los cargamos
      final List<dynamic> decoded = jsonDecode(usuariosGuardados);
      setState(() {
        _usuarios = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
      });
    } else {
      // Primera vez: cargar desde el JSON de GitHub
      final url = Uri.parse(
        'https://raw.githubusercontent.com/petrlikperu2025/FORMATO/refs/heads/main/usuarios.json',
      );
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final List<dynamic> usuariosJson = jsonDecode(response.body);
          setState(() {
            _usuarios = usuariosJson
                .map((e) => Map<String, dynamic>.from(e))
                .toList();
          });
          // Guardar en SharedPreferences
          await prefs.setString('usuarios', jsonEncode(_usuarios));
        }
      } catch (e) {
        print('Error cargando usuarios iniciales: $e');
      }
    }
  }

  // Guardar la lista actual en SharedPreferences
  Future<void> _guardarUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuarios', jsonEncode(_usuarios));
  }

  // Método que se pasa a Registrar.dart para añadir un nuevo usuario
  void _agregarUsuario(Map<String, String> nuevoUsuario) {
    setState(() {
      _usuarios.add({
        'correo': nuevoUsuario['correo']!,
        'clave': nuevoUsuario['clave']!,
        'codigo': 'U${_usuarios.length + 1}',
      });
    });
    _guardarUsuarios(); // persistencia
  }

  Future<void> _validarAcceso() async {
    setState(() => _isLoading = true);

    final String usuario = _usuarioController.text.trim();
    final String clave = _claveController.text.trim();

    if (usuario.isEmpty || clave.isEmpty) {
      _mostrarDialogoError();
      setState(() => _isLoading = false);
      return;
    }

    // Buscar en la lista combinada (original + registrados)
    final valido = _usuarios.any(
      (user) => user['correo'] == usuario && user['clave'] == clave,
    );

    if (valido) {
      _mostrarDialogoExito(usuario);
    } else {
      _mostrarDialogoError();
    }

    setState(() => _isLoading = false);
  }

 void _mostrarDialogoExito(String usuario) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Usuario validado'),
        content: Text('Bienvenido $usuario a la aplicación'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // cierra el diálogo
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Principal(usuario: usuario),
                ),
              );
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error de validación'),
        content: const Text(
          'Usuario o contraseña incorrecta por favor intente de nuevo o regístrese',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _pageRegistrar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Registrar(onUserRegistered: _agregarUsuario),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 100),
            const SizedBox(height: 40),
            TextField(
              controller: _usuarioController,
              decoration: const InputDecoration(
                hintText: 'Por favor ingrese el nombre de usuario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _claveController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Por favor ingrese su contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _validarAcceso,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Ingresar'),
                  ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _pageRegistrar,
              child: const Text('¿No estás registrado? Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla Home opcional (puedes mantenerla o no)
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenido')),
      body: const Center(child: Text('Has iniciado sesión correctamente')),
    );
  }
}
