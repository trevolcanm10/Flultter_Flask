import 'package:flutter/material.dart';
import 'bienvenida.dart';
import 'perfil.dart';
import 'contacto.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/person_ico.png'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.waving_hand),
            title: const Text('Bienvenida'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BienvenidaPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PerfilPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Contacto'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactoPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
