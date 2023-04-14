import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/models.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng _center = const LatLng(40.416775, -3.70379);

  //obtener lugares api
  List<Lugar> lugares = [];

  Future<void> _getLugares() async {
    final response = await http.get(Uri.parse('https://tour-boost-api.vercel.app/lugar'));
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      lugares = parsed.map<Lugar>((json) => Lugar.fromJson(json)).toList();
      setState(() {});
    } else {
      throw Exception('Failed to load lugares');
    }
  }

  //
  List<Marker> _markers = [];
  GoogleMapController? _controller;

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    //lugares    
    _getLugares();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;

    //marcadores a añadir
    /*for (int i = 0; i < lugares.length; i++) {
      addMarker(
          MarkerId(lugares[i].idLugar as String),
          LatLng(lugares[i].latitud, lugares[i].longitud),
          lugares[i].tipoLugar,
          lugares[i].nombrePais,
          lugares[i].nombrePais);
    } */

    addMarker(
        MarkerId('test'),
        LatLng(lugares[0].latitud, lugares[0].longitud),
        'Procisa',
        'Poligono pisa, Sevilla.',
        'Pepe');    
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();

    if (status == PermissionStatus.denied) {
      showDialog(
        context: context,
        builder: (BuildContext context) =>  AlertDialog(
          title: Text('Permisos de ubicación'),
          content: Text(
              'Es necesario conceder permisos de ubicación para utilizar el mapa.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => openAppSettings(),
              child: Text('Abrir ajustes'),
            ),
          ],
        ),
      );
    } else if (status == PermissionStatus.granted) {
      // Continuar con la lógica de la aplicación.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        elevation: 0,
      ),
      body: Column(
        children: [         
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 15.0,
              ),
              markers: Set<Marker>.of(_markers),
            ),
          ),
        ],
      ),
    );
  }

  //add marcadores
  void addMarker(MarkerId markerId, LatLng position, String title,
      String snippet, String ontap) {
    setState(() {
      _markers.add(
        Marker(
          markerId: markerId,
          position: position,
          infoWindow: InfoWindow(
            title: title,
            snippet: snippet,
          ),
          //al pulsar un marcador
          onTap: () {
            print(ontap);
          },
          //
        ),
      );
    });
  }
}
