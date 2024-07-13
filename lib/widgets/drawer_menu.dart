import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            title: Text("Mi perfil"),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'home');
            },
          ),
          const Divider(),
          ListTile(
            title: Text("Turnos agendados"),
            leading: Icon(Icons.calendar_today),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'misTurnosDelDia');
            },
          ),
          const Divider(),
          ListTile(
            title: Text("Agendar nuevo turno"),
            leading: Icon(Icons.add),
            onTap: () {},
          ),
          const Divider(),
        ],
      ),
    );
  }
}
