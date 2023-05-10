class Recomendacion {
  final int idRecomendacion;
  final String nombre;
  final String imagen;
  final String descripcion;
  final int idLugar;

  Recomendacion({
    required this.idRecomendacion,
    required this.nombre,
    required this.imagen,
    required this.descripcion,
    required this.idLugar,
  });

  factory Recomendacion.fromJson(Map<String, dynamic> json) {
    return Recomendacion(
      idRecomendacion: json['idRecomendacion'],
      nombre: json['nombre'],
      imagen: json['imagen'],
      idLugar: json['idLugar'],
      descripcion: json['descripcion'],
    );
  }
}
