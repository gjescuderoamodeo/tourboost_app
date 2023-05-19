class MarcadorF {
  final int idUsuario;
  final int idLugar;

  MarcadorF({
    required this.idUsuario,
    required this.idLugar,
  });

  factory MarcadorF.fromJson(Map<String, dynamic> json) {
    return MarcadorF(
      idUsuario: json['idUsuario'],
      idLugar: json['idLugar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'idLugar': idLugar,
    };
  }
}
