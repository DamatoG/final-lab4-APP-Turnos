import 'dart:convert';

import 'package:appturnos/widgets/barra_navegacion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
//import 'package:provider/provider.dart';

import '../models/Empleado.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  Empleado? _empleadoSeleccionado;
  List<Empleado> _listaEmpleados = [];
  late Map<String, dynamic> horariosDisponibles = {};

  @override
  void initState() {
    super.initState();
    _fetchEmpleados();
  }

  Future<void> _fetchEmpleados() async {
    final url = Uri.parse('http://10.0.2.2:8080/api/v1/empleados/');

    try {
      final response = await http.get(url);
      print("Conectado a la API para recuperar listado de empleados");
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _listaEmpleados = data.map((item) {
            return Empleado.fromJson(item);
          }).toList();
        });
      } else if (response.statusCode == 404) {
        setState(() {
          // Manejar caso de error 404
        });
      } else {
        throw Exception('Failed to load empleados');
      }
    } catch (e) {
      setState(() {
        // Manejar errores de conexión
      });
      print('Error fetching empleados: $e');
    }
  }

  Future<void> cargarHorariosDisponibles() async {
    if (_empleadoSeleccionado == null) return;
    print("Empleado seleccionado desde GET cargaHorarios");
    print(_empleadoSeleccionado!.nombre);
    //final fechaHoy = DateTime.now().toIso8601String().split('T')[0];

    // final url = Uri.parse(
    //     'http://10.0.2.2:8080/api/v1/turnos/${_empleadoSeleccionado!.id}/turnos-disponibles?fecha=$formattedDate');
    final url = Uri.parse(
        'http://10.0.2.2:8080/api/v1/turnos/${_empleadoSeleccionado!.id}/turnos-disponibles?fecha=2024-07-11');

    print(url.toString());
    final response = await http.get(url);
    print("Conectado a la API para recuperar listado de empleados");
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      print(responseBody);
      setState(() {
        horariosDisponibles = responseBody;
      });
    } else {
      // Manejar error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("CitAPP"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Center(
            child: Column(
              children: [
                Text(
                  formattedDate,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DropdownButton<Empleado>(
                        hint: Text('Seleccione una opción'),
                        value: _empleadoSeleccionado,
                        items: _listaEmpleados.map((empleado) {
                          return DropdownMenuItem<Empleado>(
                            value: empleado,
                            child: Text(empleado.nombre),
                          );
                        }).toList(),
                        onChanged: (Empleado? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _empleadoSeleccionado = newValue;
                              cargarHorariosDisponibles();
                            });
                          }
                        },
                      ),
                    ]),
                SizedBox(height: 20),
                _empleadoSeleccionado != null
                    ? Card(
                        elevation: 3,
                        borderOnForeground: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            'Perfil del Empleado',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  ListTile(
                                    leading: Icon(Icons.person),
                                    title: Text(
                                      _empleadoSeleccionado!.nombre,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'ID: ${_empleadoSeleccionado!.id}',
                                    ),
                                  ),
                                  Divider(),
                                  ListTile(
                                    leading: Icon(Icons.phone),
                                    title:
                                        Text(_empleadoSeleccionado!.telefono),
                                    subtitle: Text('Teléfono'),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.email),
                                    title: Text(_empleadoSeleccionado!.correo),
                                    subtitle: Text('Correo Electrónico'),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.calendar_today),
                                    title: Text(
                                      'Fecha de Ingreso:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                        _empleadoSeleccionado!.fechaIngreso),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : Text(''),
                SizedBox(
                  height: 30,
                ),
                horariosDisponibles.isEmpty
                    ? Text(
                        "Seleccione un empleado para ver sus turnos disponibles")
                    : horariosDisponibles['turnosDisponibles'].length >= 1
                        ? Expanded(
                            child: Column(
                              children: [
                                Text("Turnos disponibles:",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3, // Número de columnas
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                      childAspectRatio:
                                          2.0, // Ajustar este valor según tus necesidades
                                    ),
                                    itemCount:
                                        horariosDisponibles['turnosDisponibles']
                                            .length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        elevation: 2,
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              horariosDisponibles[
                                                  'turnosDisponibles'][index],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 14.0),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Text(
                            "No existen turnos disponibles para el dia ${formattedDate}"),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BarraNavegacion());
  }
}
