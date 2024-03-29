import 'package:flutter/material.dart';
import 'package:tourboost_app/models/models.dart';
import 'package:tourboost_app/screens/screens.dart';
import 'package:tourboost_app/services/services.dart';
import 'package:tourboost_app/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';

class HotelScreen extends StatefulWidget {
  const HotelScreen({Key? key}) : super(key: key);

  //Text('Nombre del hotel: ${datos["nombre"]}'),

  @override
  State<HotelScreen> createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  //rango fecha
  DateTimeRange? _selectedRange = null;

//cuadro dialogo elegir fecha
  Future<void> _presentDateRangePicker(BuildContext context) async {
    //rango inicial
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now(),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      saveText: "Elegir fecha",
      helpText: "Elige fecha inicio fin",
      firstDate: DateTime.now(),
      lastDate: DateTime(2024),
      initialDateRange: _selectedRange ?? initialDateRange,
    );
    if (newDateRange == null) {
      return;
    }
    setState(() {
      _selectedRange = newDateRange;
    });
    //se ejecuta al darle a guardar
    //print('La fecha seleccionada es $_selectedRange');
  }
//

  //función obtener id usuario
  Future<void> _getUserId() async {
    final AuthService authService = AuthService();

    //obtener token
    final token = await authService.readToken();
    final userId = authService.getUserIdFromToken(token);

    _idUser = userId;
  }

  //función asincrona crear reserva
  void _crearReserva(int idUsuario, int numeroReservantes, int idHotel,
      String fecha_inicio, String fecha_fin) async {
    final nuevaReserva = {
      "idUsuario": idUsuario,
      "fecha_inicio": fecha_inicio,
      "fecha_fin": fecha_fin,
      "idHotel": idHotel,
      "numeroPersonas": numeroReservantes,
      "expirado": false,
    };

    final response = await http.post(
      Uri.parse('https://tour-boost-api.vercel.app/reserva'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(nuevaReserva),
    );

    //toast de respuesta
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Reserva creada",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.submitButton,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Error al crear la Reserva",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.alert,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  //

  late int _idUser;

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  @override
  Widget build(BuildContext context) {
    //variable menú desplegable
    SampleItem? selectedMenu;

    //datos pasados de hoteles screen
    final datos = ModalRoute.of(context)!.settings.arguments as Hotel;
    String dirrecionHotel = datos.direccion;
    int idHotel = datos.idHotel;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(datos.nombre),
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
          ListTile(
            title: const Text(
              'Crear Reserva',
              style: TextStyle(fontSize: 20),
            ),
            trailing: const Icon(Icons.add),
            onTap: () {
              //reservas alert
              //_presentDateRangePicker(context);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  int numeroReserva = 0;

                  return AlertDialog(
                    title: const Text('Crear Reserva'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            numeroReserva = int.parse(value);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Número a reservar',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          child: const Text('Elegir fecha'),
                          onPressed: () async {
                            await _presentDateRangePicker(context);
                            setState(() {});
                          },
                        ),
                        //no se actualiza el valor y queda feo
                        /*const Text("fecha elegida:"),
                        Text(
                          _selectedRange != null
                              ? '${DateFormat.yMMMMd().format(_selectedRange!.start)} - ${DateFormat.yMMMMd().format(_selectedRange!.end)}'
                              : 'Ningún rango seleccionado',
                        ),*/
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Crear'),
                        onPressed: () {
                          if (_selectedRange == null) {
                            Fluttertoast.showToast(
                                msg: "Seleccione una fecha",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 3,
                                backgroundColor: AppTheme.alert,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else if (numeroReserva <= 0) {
                            Fluttertoast.showToast(
                                msg: "Seleccione una cantidad a reservar",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 3,
                                backgroundColor: AppTheme.alert,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            //creo la reseva
                            _crearReserva(
                                _idUser,
                                numeroReserva,
                                idHotel,
                                _selectedRange!.start.toString(),
                                _selectedRange!.end.toString());

                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
          //opcion ver en el mapa el hotel
          ListTile(
            hoverColor: AppTheme.settingsButton,
            title: const Text(
              'Ver en el Mapa',
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text(datos.direccion),
            trailing: const Icon(Icons.map),
            onTap: () async {
              final url =
                  'https://www.google.com/maps/search/?api=1&query=$dirrecionHotel';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'No se pudo abrir el mapa.';
              }
            },
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
          //opcion llamar al hotel
          ListTile(
            title: const Text(
              'Llamar por telefono',
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text(datos.telefono_contacto),
            trailing: const Icon(Icons.call),
            /*onTap: () async {
              final url =
                  'https://www.google.com/maps/search/?api=1&query=$dirrecionHotel';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'No se pudo abrir el mapa.';
              }
            },*/
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
        ],
      ),
    );
  }
}
