import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tourboost_app/models/models.dart';
import 'package:tourboost_app/screens/screens.dart';
import 'package:tourboost_app/services/services.dart';
import 'package:tourboost_app/theme/app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class MarcadoresScreen extends StatefulWidget {
  const MarcadoresScreen({super.key});

  @override
  State<MarcadoresScreen> createState() => _MarcadoresScreenState();
}

class _MarcadoresScreenState extends State<MarcadoresScreen> {
  //variable menú desplegable
  SampleItem? selectedMenu;

  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();

  //obtener reservas api
  List<Lugar> lugares = [];

  Future<void> _getMarcadores() async {
    final AuthService authService = AuthService();

    //obtener token
    final token = await authService.readToken();
    final userId = authService.getUserIdFromToken(token);

    final response = await http
        .get(Uri.parse('https://tour-boost-api.vercel.app/marcador/$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> marcadoresJson = jsonDecode(response.body);

      for (var marcadorJson in marcadoresJson) {
        final int idLugar = marcadorJson['idLugar'];
        //ahora llamada a sacar lugar por id
        final response2 = await http
            .get(Uri.parse('https://tour-boost-api.vercel.app/lugar/$idLugar'));

        if (response2.statusCode == 200) {
          final lugarJson = jsonDecode(response2.body);
          final Lugar lugar = Lugar.fromJson(lugarJson);
          lugares.add(lugar);
        }
      }
      setState(() {});
    } else {
      throw Exception('Failed to load marcadores user');
    }
  }

  //función asincrona borrar marcador favorito
  void _borrarMarcadorF(int rowIndex) async {
    int idLugar = lugares[rowIndex].idLugar;
    final AuthService authService = AuthService();

    //obtener token
    final token = await authService.readToken();
    final userId = authService.getUserIdFromToken(token);

    final body = {
      'idLugar': idLugar,
      'idUsuario':userId
    };

    final response = await http.delete(
      Uri.parse('https://tour-boost-api.vercel.app/marcador'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    //toast de respuesta
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Marcador favorito borrado correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 168, 239, 4),
          textColor: Colors.white,
          fontSize: 16.0);
          lugares.clear();
      _getMarcadores(); //recargo la vista
    } else {
      Fluttertoast.showToast(
          msg: "Error al borrar el marcador",
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
    _getMarcadores();
  }

  @override
  Widget build(BuildContext context) {
    /*final List<Lugar> lugares = marcadoresUser.map((lugarData) {
      return Lugar(
        nombreLugar: lugarData['nombreLugar'],
        name: lugarData['nombre'],
      );
    }).toList();*/

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text(
          "Mis marcadores favoritos",
          style: TextStyle(fontSize: 16),
        ),
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
      body: SfDataGrid(
        columnWidthMode: ColumnWidthMode.fill,
        allowSwiping: true,
        swipeMaxOffset: 100,
        endSwipeActionsBuilder:
            (BuildContext context, DataGridRow row, int rowIndex) {
          return GestureDetector(
            onTap: () {
              //Navigator.pushNamed(context,
              //    'alert'); // <---- esta línea para navegar a la página 'alert'
              setState(() {
                _borrarMarcadorF(rowIndex);
              });
            },
            child: Container(
              color: Colors.redAccent, // <---- cambia el color a rojo
              child: const Center(
                child: Icon(Icons.delete), // <---- cambia el icono a borrar
              ),
            ),
          );
        },
        //al desplazarse al otro lado
        startSwipeActionsBuilder:
            (BuildContext context, DataGridRow row, int rowIndex) {
          return GestureDetector(
            onTap: () async {
              String lugarRow = lugares[rowIndex].nombre;
              final url =
                  'https://www.google.com/maps/search/?api=1&query=$lugarRow';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'No se pudo abrir el mapa.';
              }
            },
            child: Container(
              color: const Color.fromARGB(255, 72, 193, 48),
              child: const Center(
                child: Icon(
                  Icons.map_rounded,
                  size: 29,
                ),
              ),
            ),
          );
        },
        columns: <GridColumn>[
          GridColumn(
            columnName: 'nombre',
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Nombre',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
            columnName: 'nombreLugar',
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Pais',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
        source: LugarDataSource(
          lugares: lugares,
        ),
      ),
    );
  }
}


class LugarDataSource extends DataGridSource {
  LugarDataSource({required List<Lugar> lugares}) {
    dataGridRows = lugares
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(
                columnName: 'nombre',
                value: dataGridRow.nombre,
              ),
              DataGridCell<String>(
                columnName: 'nombreLugar',
                value: dataGridRow.nombrePais,
              ),
            ]))
        .toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }

  void updateDataGridSource() {
    notifyListeners();
  }
}
