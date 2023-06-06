import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tourboost_app/screens/screens.dart';
import 'package:tourboost_app/services/services.dart';
import 'package:tourboost_app/theme/app_theme.dart';

import '../models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HotelesScreen extends StatefulWidget {
  const HotelesScreen({super.key});

  @override
  State<HotelesScreen> createState() => _HotelesScreenState();
}

class _HotelesScreenState extends State<HotelesScreen> {
  //variable menú desplegable
  SampleItem? selectedMenu;

  //obtener hoteles api
  List<Hotel> hoteles = [];

  Future<void> _getHoteles(String pais) async {
    final response = await http
        .get(Uri.parse('https://tour-boost-api.vercel.app/hotelpais/$pais'));

    //print(response.body);

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      hoteles = parsed.map<Hotel>((json) => Hotel.fromJson(json)).toList();
      setState(() {});
    } else {
      throw Exception('Failed to load hoteles');
    }
  } /*

  @override
  void initState() {
    super.initState();
    _getHoteles();
  }*/

  @override
  Widget build(BuildContext context) {
    //datos pasados de paises screen
    final nombrePais = ModalRoute.of(context)!.settings.arguments as String;
    _getHoteles(nombrePais);

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text("Hoteles disponibles"),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: CircleAvatar(
              child: PopupMenuButton<SampleItem>(
                initialValue: selectedMenu,
                onSelected: (SampleItem item) {
                  setState(() {
                    selectedMenu = item;
                  });

                  //navegar a la pantalla de Configuración
                  if (item == SampleItem.itemOne) {
                    Navigator.pushNamed(context, 'configuraciones');
                  }
                  //logout
                  if (item == SampleItem.itemThree) {
                    final AuthService authService = AuthService();
                    authService.logout();
                    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
                    //Navigator.pushNamed(context, 'login');
                  }
                },
                icon: const Icon(Icons.person),
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<SampleItem>>[
                  PopupMenuItem<SampleItem>(
                    value: SampleItem.itemOne,
                    child: Row(
                      children: const [
                        Text('Configuración'),
                        SizedBox(width: 20),
                        Icon(Icons.build_rounded, color: Colors.black)
                      ],
                    ),
                  ),
                  PopupMenuItem<SampleItem>(
                    value: SampleItem.itemThree,
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
      body: ListView(
        children: [
          ...hoteles
              .map((e) => ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, 'hotel', arguments: e);
                  },
                  title: Text(e.nombre),
                  trailing: const Icon(Icons.arrow_forward_ios_sharp)))
              .toList()
        ],
      ),
    );
  }
}
