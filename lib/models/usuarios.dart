class Usuario {
  final int idUsuario;
  final bool admin;
  final String correo;
  final String apellidos;
  final String nombre;

  Usuario({
    required this.idUsuario,
    required this.admin,
    required this.correo,
    required this.apellidos,
    required this.nombre,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json['idUsuario'],
      admin: json['admin'],
      correo: json['tipo_Usuario'],
      nombre: json['nombre'],
      apellidos: json['apellidos'],
    );
  }
}
