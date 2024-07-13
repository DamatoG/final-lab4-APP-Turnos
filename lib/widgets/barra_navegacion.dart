import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/barra_navegacion_provider.dart';

class BarraNavegacion extends StatelessWidget {
  const BarraNavegacion({super.key});

  void _onItemTapped(BuildContext context, int index) {
    Provider.of<HandlerStateBarraNavegacion>(context, listen: false)
        .setBtnSeleccionado = index;

    if (index == 0) {
      Navigator.pushReplacementNamed(context, 'home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, 'misTurnosDelDia');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, 'agendarTurno');
    }
  }

  @override
  Widget build(BuildContext context) {
    final botonera = Provider.of<HandlerStateBarraNavegacion>(context);

    return BottomNavigationBar(
        currentIndex: botonera.getBtnSeleccionado,
        selectedItemColor: const Color.fromARGB(255, 37, 106, 163),
        unselectedItemColor: Colors.grey,
        onTap: (index) => _onItemTapped(context, index),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'Mis Turnos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Agendar',
          ),
        ]);
  }
}
