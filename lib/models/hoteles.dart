class Hotel {
  final int idHotel;  
  final int idLugar;
  final int plazasTotales;
  final int plazasDisponibles;
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
      plazasTotales: json['plazasTotales'],
      plazasDisponibles: json['plazasDisponibles'],
      direccion: json['direccion'],
      nombre: json['nombre'],
      telefono_contacto: json['telefono_contacto'],
    );
  }
}