import 'package:flutter/foundation.dart';
import '../models/Empleado.dart';

class EmpleadoProvider with ChangeNotifier {
  Empleado? _empleadoSeleccionado;
  List<Empleado> _listaEmpleados = [];

  Empleado? get empleadoSeleccionado => _empleadoSeleccionado;
  List<Empleado> get listaEmpleados => _listaEmpleados;

  void seleccionarEmpleado(Empleado empleado) {
    _empleadoSeleccionado = empleado;
    notifyListeners();
  }

  void setListaEmpleados(List<Empleado> empleados) {
    _listaEmpleados = empleados;
    notifyListeners();
  }
}
