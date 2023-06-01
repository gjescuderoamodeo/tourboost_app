import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tourboost_app/screens/screens.dart';
import 'package:tourboost_app/services/services.dart';
import 'package:tourboost_app/theme/app_theme.dart';

import '../models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaisesScreen extends StatefulWidget {
  const PaisesScreen({super.key});

  @override
  State<PaisesScreen> createState() => _PaisesScreenState();
}

class _PaisesScreenState extends State<PaisesScreen> {
  //variable menú desplegable
  SampleItem? selectedMenu;

  //obtener paises api
  List<Pais> paises = [];

  Future<void> _getPaises() async {
    final response =
        await http.get(Uri.parse('https://tour-boost-api.vercel.app/pais'));

    //print(response.body);

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      paises = parsed.map<Pais>((json) => Pais.fromJson(json)).toList();
      setState(() {});
    } else {
      throw Exception('Failed to load paises');
    }
  }

  @override
  void initState() {
    super.initState();
    _getPaises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text("Paises disponibles"),
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
                    Navigator.pushNamed(context, 'configuracion');
                  }
                  //logout
                  if (item == SampleItem.itemThree) {
                    final AuthService authService = AuthService();
                    authService.logout();

                    Navigator.pushNamed(context, 'login');
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
          ...paises
              .map((e) => ListTile(
                  onTap: () {
                    //le paso el nombre del pais y en hoteles hará consulta a "/hotelpais/nombrepais"
                    Navigator.pushNamed(context, 'hoteles',
                        arguments: e.nombre);
                  },
                  title: Text(e.nombre),
                  trailing: const Icon(Icons.arrow_forward_ios_sharp)))
              .toList()
        ],
      ),
    );
  }
}
