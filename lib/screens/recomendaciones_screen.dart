import 'package:flutter/material.dart';
import 'package:tourboost_app/models/models.dart';
import 'package:tourboost_app/services/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tourboost_app/theme/app_theme.dart';
import '../widgets/widgets.dart';
import 'screens.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecomendacionScreen extends StatefulWidget {
  RecomendacionScreen({Key? key}) : super(key: key);

  @override
  State<RecomendacionScreen> createState() => _RecomendacionScreenState();
}

class _RecomendacionScreenState extends State<RecomendacionScreen> {
  //variable menú desplegable
  SampleItem4? selectedMenu;

  //obtener recomendaciones_lugar api
  List<Recomendacion> recomendaciones_lugar = [];

  Future<void> _getRecomendacion(String nombre) async {
    final response = await http.post(
        Uri.parse('https://tour-boost-api.vercel.app/lugarrecomendacion'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'nombre': nombre}));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      recomendaciones_lugar = parsed
          .map<Recomendacion>((json) => Recomendacion.fromJson(json))
          .toList();
      setState(() {});
    } else {
      throw Exception('Failed to load recomendaciones_lugar');
    }
  }

  //añadir marcador a favoritos
  Future<void> _addMarcador() async {    
    final AuthService authService = AuthService();
    //obtener token
    final token = await authService.readToken();
    final userId = authService.getUserIdFromToken(token);

    //sacar el id del lugar
    final idLugar = recomendaciones_lugar[0].idLugar;

    final response = await http.post(
        Uri.parse('https://tour-boost-api.vercel.app/marcador'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'idUsuario': userId,'idLugar':idLugar}));

     //toast de respuesta
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Hotel modificado correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 168, 239, 4),
          textColor: Colors.white,
          fontSize: 16.0);
      //recargar la vista
    } else {
      Fluttertoast.showToast(
          msg: "Error al modificar el Hotel",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 251, 0, 0),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  //

  @override
  void initState() {
    super.initState();
    //_getRecomendacion();
  }

  @override
  Widget build(BuildContext context) {
    //datos pasados de recomendaciones_lugar screen
    String datos = ModalRoute.of(context)!.settings.arguments.toString();
    _getRecomendacion(datos);

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(
          "Recomendaciones de $datos",
          style: const TextStyle(fontSize: 15),
        ),
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
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                ...recomendaciones_lugar.asMap().entries.map((entry) {
                  //final index = entry.key;
                  final recomendacion = entry.value;
                  return Column(
                    children: [
                      CustomCardType(
                        imageUrl: recomendacion.imagen,
                        mensaje: recomendacion.descripcion,
                        nombre: recomendacion.nombre,
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Material(
              color: const Color.fromARGB(255, 179, 59, 175),
              child: InkWell(
                onTap: () {
                  _addMarcador();
                },
                splashColor: const Color.fromARGB(255, 17, 236, 2),
                child: Container(
                  height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Añadir a favoritos',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Icon(Icons.star,color: Colors.amber,)
                      ],
                    ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
