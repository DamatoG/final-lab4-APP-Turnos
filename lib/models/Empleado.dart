class Empleado {
  final int id;
  final String nombre;
  final String telefono;
  final String correo;
  final String fechaIngreso;

  Empleado({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.correo,
    required this.fechaIngreso,
  });

  factory Empleado.fromJson(Map<String, dynamic> json) {
    return Empleado(
      id: json['ID_Empleado'],
      nombre: json['nombre'],
      telefono: json['telefono'],
      correo: json['correo'],
      fechaIngreso: json['fechaIngreso'],
    );
  }
}
