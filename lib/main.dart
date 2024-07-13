//import 'dart:js';

import 'package:appturnos/pages/pages.dart';
import 'package:appturnos/providers/barra_navegacion_provider.dart';
import 'package:appturnos/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/perfil_seleccionado_provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    // ChangeNotifierProvider<ThemeProvider>(
    //     create: (context) => ThemeProvider(isDarkMode: true)),
    ChangeNotifierProvider<HandlerStateBarraNavegacion>(
        create: (context) => HandlerStateBarraNavegacion()),
    ChangeNotifierProvider<EmpleadoProvider>(create: (_) => EmpleadoProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final bool ligthTheme = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APP Turnos',
      theme: (ligthTheme) ? ThemeData.dark() : ThemeData.light(),
      initialRoute: 'home',
      routes: {
        'home': (context) => HomePage(),
        'misTurnosDelDia': (context) => MisTurnosPage(),
        'agendarTurno': (context) => const AgendarTurnoPage(),
      },
    );
  }
}
