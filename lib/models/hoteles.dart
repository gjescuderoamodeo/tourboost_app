class Hotel {
  final int idHotel;  
  final int idLugar;
  final double plazasTotales;
  final double plazasDisponibles;
  final String direccion;
  final String telefono_contacto;
  final String nombre;

  Hotel({
    required this.idHotel,
    required this.idLugar,
    required this.plazasTotales,
    required this.plazasDisponibles,
    required this.direccion,
    required this.telefono_contacto,
    required this.nombre,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      idHotel: json['idHotel'],
      idLugar: json['idLugar'],
      plazasTotales: json['plazasTotales'].toDouble(),
      plazasDisponibles: json['plazasDisponibles'].toDouble(),
      direccion: json['direccion'],
      nombre: json['nombre'],
      telefono_contacto: json['telefono_contacto'],
    );
  }
}