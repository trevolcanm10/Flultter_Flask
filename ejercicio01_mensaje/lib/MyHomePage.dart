import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  String _resultado = 'Result !!!';

  void _calcular() {
    int? num1 = int.tryParse(_controller1.text);
    int? num2 = int.tryParse(_controller2.text);

    if (num1 != null && num2 != null) {
      setState(() {
        _resultado = 'Result: ${num1 + num2}';
      });
    } else {
      setState(() {
        _resultado = 'Error: ingresa números';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Example 01')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller1,
              decoration: const InputDecoration(
                labelText: 'Number 1:',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller2,
              decoration: const InputDecoration(
                labelText: 'Number 2:',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calcular,
              child: const Text('Calculate'),
            ),
            const SizedBox(height: 24),
            Text(
              _resultado,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
