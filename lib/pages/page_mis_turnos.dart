import 'dart:convert';

import 'package:appturnos/widgets/barra_navegacion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/Empleado.dart';

import '../widgets/turno_dia_card_widget.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MisTurnosPage extends StatefulWidget {
  MisTurnosPage({Key? key}) : super(key: key);

  @override
  _MisTurnosPageState createState() => _MisTurnosPageState();
}

class _MisTurnosPageState extends State<MisTurnosPage> {
  List<dynamic> _turnosAgendados = [];
  bool _isLoading = true; // Variable para indicar si está cargando
  DateTime? _selectedStartDate;
  bool _isEmpty = true;

  Empleado? _empleadoSeleccionado;
  List<Empleado> _listaEmpleados = [];

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _fetchEmpleados();
  }

//consumir srv empleados
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

//Seleccionar fecha para filtrar turnos
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
      });
    }
  }

//Consumit turnos segun id empleado y pudiendo filtrar por fecha
  Future<void> _fetchTurnos() async {
    late final Uri url;

    print(_selectedStartDate);

    if (_selectedStartDate != null) {
      final formattedDate = formatter.format(_selectedStartDate!);
      url = Uri.parse(
          'http://10.0.2.2:8080/api/v1/turnos/${_empleadoSeleccionado!.id}?fecha=$formattedDate');
    } else {
      url = Uri.parse(
          'http://10.0.2.2:8080/api/v1/turnos/${_empleadoSeleccionado!.id}');
    }

    setState(() {
      _isLoading = true;
      _isEmpty = false;
    });

    try {
      final response = await http.get(url);
      print("Llamado srv get turnos. URL:  ${url}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _turnosAgendados = data;
          _isLoading = false;
          _isEmpty = data.isEmpty;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _isLoading = false;
          _isEmpty = true;
        });
      } else {
        throw Exception('Failed to load turnos');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching turnos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CitAPP"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            //Desplegable de empleados
            DropdownButton<Empleado>(
              hint: Text('Seleccione una opción',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              value: _empleadoSeleccionado,
              items: _listaEmpleados.map((empleado) {
                return DropdownMenuItem<Empleado>(
                  value: empleado,
                  child: Text(empleado.nombre,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                );
              }).toList(),
              onChanged: (Empleado? newValue) {
                if (newValue != null) {
                  setState(() {
                    _empleadoSeleccionado = newValue;
                    _fetchTurnos();
                  });
                }
              },
            ),
            //Calendario
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _selectStartDate(context);
                  },
                  child: Text(
                      _selectedStartDate == null
                          ? 'Filtrar por fecha'
                          : 'Filtro: ${formatter.format(_selectedStartDate!)}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  onPressed: () {
                    _fetchTurnos();
                  },
                  child: Text('Aplicar filtro',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                _selectedStartDate != null
                    ? ElevatedButton(
                        onPressed: () {
                          _selectedStartDate = null;
                          _fetchTurnos();
                        },
                        child: Text('Limpiar filtro',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      )
                    : Text(""),
              ],
            ),
          ]),

          //Listado de turnos
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _isEmpty
                    ? const Text(
                        "No existen turnos disponibles en ese rango de fechas")
                    : ListView.builder(
                        itemCount: _turnosAgendados.length,
                        itemBuilder: (context, index) {
                          final dia = _turnosAgendados[index];
                          final turnos = dia['turnos'];

                          return ExpansionTile(
                              title: Text(
                                dia['fecha'],
                                style: TextStyle(fontSize: 18),
                              ),
                              children: [
                                ListView.builder(
                                  shrinkWrap:
                                      true, // Ajusta el tamaño al contenido
                                  physics:
                                      NeverScrollableScrollPhysics(), // Desactiva el scroll
                                  itemCount: turnos.length,
                                  itemBuilder: (context, index) {
                                    final turno = turnos[index];
                                    return CardTurnoDia(
                                      hora: turno['hora']!,
                                      nombreCliente: turno['clienteNombre']!,
                                      servicio: turno['servicioNombre']!,
                                      telefonoCliente:
                                          turno['clienteTelefono']!,
                                      correoCliente: turno['clienteNombre']! +
                                          "@gmail.com",
                                    );
                                  },
                                )
                              ]);
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: BarraNavegacion(),
    );
  }
}
