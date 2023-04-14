import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/models.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng _center = const LatLng(37.356986424774405, -6.053150628892014);
  List<Marker> _markers = [];
  GoogleMapController? _controller;

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;

    //marcadores a añadir
    addMarker(
        MarkerId('procisa'),
        LatLng(37.356986424774405, -6.053150628892014),
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
