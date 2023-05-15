import 'package:flutter/material.dart';
import 'package:tourboost_app/models/models.dart';
import 'package:tourboost_app/screens/screens.dart';
import 'package:tourboost_app/services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import 'package:fluttertoast/fluttertoast.dart';

class HotelScreen extends StatefulWidget {
  const HotelScreen({super.key});

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
      firstDate: DateTime(2023),
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

  @override
  Widget build(BuildContext context) {
    //variable menú desplegable
    SampleItem? selectedMenu;

    //datos pasados de hoteles screen
    final datos = ModalRoute.of(context)!.settings.arguments as Hotel;

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
                  const PopupMenuItem<SampleItem>(
                    value: SampleItem.itemTwo,
                    child: Text('Item 2'),
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
                            _presentDateRangePicker(context);
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
                                backgroundColor:
                                    const Color.fromARGB(255, 251, 0, 0),
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else if (numeroReserva <= 0) {
                            Fluttertoast.showToast(
                                msg: "Seleccione una cantidad a reservar",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 3,
                                backgroundColor:
                                    const Color.fromARGB(255, 251, 0, 0),
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
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
            title: const Text(
              'Ver en el Mapa',
              style: TextStyle(fontSize: 20),
            ),
            trailing: const Icon(Icons.map),
            onTap: () async {
              final url =
                  'https://www.google.com/maps/search/?api=1&query=Madrid';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'No se pudo abrir el mapa.';
              }
            },
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
        ],
      ),
    );
  }
}
