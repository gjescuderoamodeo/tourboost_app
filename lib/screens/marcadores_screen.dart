import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tourboost_app/models/models.dart';
import 'package:tourboost_app/screens/screens.dart';
import 'package:tourboost_app/services/services.dart';
import 'package:tourboost_app/theme/app_theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ffi';

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
                //data.removeAt(rowIndex);
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
            onTap: () {
              Navigator.pushNamed(
                  context, 'map'); // <----navegar a la página 'map'              
            },
            child: Container(
              color: Color.fromARGB(255, 36, 177, 7),
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
