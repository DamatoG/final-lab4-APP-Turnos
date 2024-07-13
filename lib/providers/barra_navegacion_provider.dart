import 'package:flutter/material.dart';

class HandlerStateBarraNavegacion extends ChangeNotifier {
  int _btnSeleccionado = 0;

  int get getBtnSeleccionado => _btnSeleccionado;

  set setBtnSeleccionado(int btnSeleccionadoNuevo) {
    _btnSeleccionado = btnSeleccionadoNuevo;
    //Cuando cambiamos el valor del boton seleccionado debemos informarselo a los widgets que utilizan este handler
    //para que los mismos puedan redibujarse
    notifyListeners(); // este método lo hace
    //print("btn seleccionado: ${getBtnSeleccionado}");
  }
}
