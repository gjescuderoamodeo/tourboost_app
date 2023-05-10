import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tourboost_app/services/services.dart';
import '../models/models.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

enum SampleItem4 { itemOne, itemTwo, itemThree }

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng _center = const LatLng(40.416775, -3.70379);

  //variable menú desplegable
  SampleItem4? selectedMenu;

  //obtener lugares api
  List<Lugar> lugares = [];

  Future<void> _getLugares() async {
    final response =
        await http.get(Uri.parse('https://tour-boost-api.vercel.app/lugar'));

    //print(response.body);

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      lugares = parsed.map<Lugar>((json) => Lugar.fromJson(json)).toList();
      setState(() {});
    } else {
      throw Exception('Failed to load lugares');
    }
  }

  //lista marcadores
  final List<Marker> _markers = [];
  GoogleMapController? _controller;

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    //lugares
    _getLugares();
    _loadLugares();
  }

  Future<void> _loadLugares() async {
    await _getLugares();
    //marcadores a añadir
    for (int i = 0; i < lugares.length; i++) {
      addMarker(
          MarkerId(lugares[i].idLugar.toString()),
          LatLng(lugares[i].latitud, lugares[i].longitud),
          lugares[i].tipoLugar,
          lugares[i].nombre,
          lugares[i].nombrePais);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;

    //marcadores a añadir
    for (int i = 0; i < lugares.length; i++) {
      addMarker(
          MarkerId(lugares[i].idLugar as String),
          LatLng(lugares[i].latitud, lugares[i].longitud),
          lugares[i].tipoLugar,
          lugares[i].nombrePais,
          lugares[i].nombrePais);
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();

    if (status == PermissionStatus.denied) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
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
        elevation: 2,
        title: const Text("Tourboost Mapa"),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: CircleAvatar(
              child: PopupMenuButton<SampleItem4>(
                initialValue: selectedMenu,
                onSelected: (SampleItem4 item) {
                  setState(() {
                    selectedMenu = item;
                  });

                  //navegar a la pantalla de Configuración
                  if (item == SampleItem4.itemOne) {
                    Navigator.pushNamed(context, 'configuracion');
                  }
                  //logout
                  if (item == SampleItem4.itemThree) {
                    final AuthService authService = AuthService();
                    authService.logout();

                    Navigator.pushNamed(context, 'login');
                  }
                },
                icon: const Icon(Icons.person),
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<SampleItem4>>[
                  PopupMenuItem<SampleItem4>(
                    value: SampleItem4.itemOne,
                    child: Row(
                      children: const [
                        Text('Configuración'),
                        SizedBox(width: 20),
                        Icon(Icons.build_rounded, color: Colors.black)
                      ],
                    ),
                  ),
                  const PopupMenuItem<SampleItem4>(
                    value: SampleItem4.itemTwo,
                    child: Text('Item 2'),
                  ),
                  PopupMenuItem<SampleItem4>(
                    value: SampleItem4.itemThree,
                    child: Row(
                      children: const [
                        Text('Cerrar Sesión'),
                        SizedBox(width: 20),
                        Icon(Icons.exit_to_app, color: Colors.black)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
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
                zoom: -200.0,
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
            //al pulsar un marcador
            onTap: () {
              //print(ontap);
              //print(ontap);
              Navigator.pushNamed(context, 'recomendacion', arguments: ontap);
            },
            //
          ),
        ),
      );
    });
  }
}
