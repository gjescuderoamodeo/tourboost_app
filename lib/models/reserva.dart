class Reserva {
  final int idReserva;
  final String fecha_inicio;
  final String fecha_fin;
  final int idUsuario;
  final int idHotel;

  Reserva({
    required this.idReserva,
    required this.fecha_inicio,
    required this.fecha_fin,
    required this.idUsuario,
    required this.idHotel,
  });

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      idReserva: json['idReserva'],
      fecha_inicio: json['fecha_inicio'],
      fecha_fin: json['fecha_fin'],
      idUsuario: json['idUsuario'],
      idHotel: json['idHotel'],
    );
  }
}
