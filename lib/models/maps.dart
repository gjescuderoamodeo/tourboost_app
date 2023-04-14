// To parse this JSON data, do
//
//     final Marcador = MarcadorFromMap(jsonString);

import 'dart:convert';

class Marcador {
    Marcador({
        required this.markerId,
        required this.latitud,
        required this.longitud,
    });

    String markerId;
    String latitud;
    String longitud;

    factory Marcador.fromJson(String str) => Marcador.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Marcador.fromMap(Map<String, dynamic> json) => Marcador(
        markerId: json["markerId"],
        latitud: json["latitud"],
        longitud: json["longitud"],
    );

    Map<String, dynamic> toMap() => {
        "markerId": markerId,
        "latitud": latitud,
        "longitud": longitud,
    };
}
