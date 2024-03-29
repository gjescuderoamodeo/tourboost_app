class Lugar {
  final int idLugar;
  final double latitud;
  final double longitud;
  final String tipoLugar;
  final String nombrePais;
  final String nombre;

  Lugar({
    required this.idLugar,
    required this.latitud,
    required this.longitud,
    required this.tipoLugar,
    required this.nombrePais,
    required this.nombre,
  });

  factory Lugar.fromJson(Map<String, dynamic> json) {
    return Lugar(
      idLugar: json['idLugar'],
      latitud: json['latitud'].toDouble(),
      longitud: json['longitud'].toDouble(),
      tipoLugar: json['tipo_lugar'],
      nombre: json['nombre'],
      nombrePais: json['nombrePais'],
    );
  }
}
