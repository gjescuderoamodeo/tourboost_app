class Usuario {
  final int idUsuario;
  final String correo;
  final String apellidos;
  final String nombre;

  Usuario({
    required this.idUsuario,
    required this.correo,
    required this.apellidos,
    required this.nombre,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json['idUsuario'],
      correo: json['correo'],
      nombre: json['nombre'],
      apellidos: json['apellidos'],
    );
  }
}
