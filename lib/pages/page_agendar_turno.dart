import 'package:flutter/material.dart';
import '../widgets/barra_navegacion.dart';

class AgendarTurnoPage extends StatelessWidget {
  const AgendarTurnoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Agendar nuevo turno"),
          centerTitle: true,
        ),
        body: const Center(
          child: Text(
            'PROXIMAENTE ... ',
            style: TextStyle(fontSize: 30),
          ),
        ),
        bottomNavigationBar: BarraNavegacion());
  }
}
