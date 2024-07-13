import 'package:flutter/material.dart';

class InfoHome extends StatelessWidget {
  final String detalle;
  final int nroDetalle;
  const InfoHome({
    required this.detalle,
    required this.nroDetalle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Ajusta la alineación aquí
            children: [
              Icon(Icons.arrow_forward_ios),
              Expanded(
                child: Text(
                  detalle,
                  style: TextStyle(
                    fontSize: 23,
                  ),
                ),
              ),
              SizedBox(width: 16), // Separación entre detalle y nroDetalle
              Text(
                nroDetalle.toString(),
                style: TextStyle(
                  fontSize: 23,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }
}
