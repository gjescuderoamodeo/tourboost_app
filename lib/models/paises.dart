class Pais {
  final String codigo_pais;
  final String nombre;

  Pais({
    required this.codigo_pais,
    required this.nombre,
  });

  factory Pais.fromJson(Map<String, dynamic> json) {
    return Pais(
      codigo_pais: json['codigo_pais'],
      nombre: json['nombre'],
    );
  }
}
