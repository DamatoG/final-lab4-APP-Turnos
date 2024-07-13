import 'package:flutter/material.dart';

class CardTurnoDia extends StatelessWidget {
  final String hora;

  final String nombreCliente;
  final String servicio;
  final String telefonoCliente;
  final String correoCliente;

  const CardTurnoDia({
    Key? key,
    required this.hora,
    required this.nombreCliente,
    required this.servicio,
    required this.telefonoCliente,
    required this.correoCliente,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Theme.of(context).colorScheme.tertiary,
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Text(
                        "$hora hs",
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cliente: $nombreCliente",
                        style: TextStyle(fontSize: 19),
                      ),
                      Text("Servicio: $servicio",
                          style: TextStyle(fontSize: 19)),
                      Text("Telefono: $telefonoCliente",
                          style: TextStyle(fontSize: 19)),
                      Text("Correo: $correoCliente",
                          style: TextStyle(fontSize: 19)),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )
              ],
            )),
      ],
    );
  }
}
