import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tourboost_app/models/models.dart';
import 'package:tourboost_app/screens/screens.dart';
import 'package:tourboost_app/services/services.dart';
import 'package:tourboost_app/theme/app_theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ffi';

class ReservasScreen extends StatefulWidget {
  const ReservasScreen({super.key});

  @override
  State<ReservasScreen> createState() => _ReservasScreenState();
}

class _ReservasScreenState extends State<ReservasScreen> {
  //variable menú desplegable
  SampleItem? selectedMenu;

  //obtener reservas api
  List<Reserva> reserva = [];

  Future<void> _getReserva() async {
    final response = await http
        .get(Uri.parse('https://tour-boost-api.vercel.app/reserva/1'));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      reserva = parsed.map<Reserva>((json) => Reserva.fromJson(json)).toList();
      setState(() {});
    } else {
      throw Exception('Failed to load Reservas');
    }
  }

  //

  //obtener hotel seleccionado
  late Hotel hotel;

  Future<void> _getHotel(int idHotel) async {
    final response = await http
        .get(Uri.parse('https://tour-boost-api.vercel.app/hotel/$idHotel'));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      hotel = Hotel.fromJson(parsed);
      setState(() {});
    } else {
      throw Exception('Failed to load Hotel');
    }
  }

  //

  @override
  void initState() {
    super.initState();
    _getReserva();
  }

  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<Reserva> reservas = reserva.map((reservaData) {
      return Reserva(
          fecha_inicio: reservaData.fecha_inicio,
          fecha_fin: reservaData.fecha_fin,
          idReserva: reservaData.idReserva,
          idHotel: reservaData.idHotel,
          idUsuario: reservaData.idUsuario);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text("Reservas hotel"),
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
            onTap: () async {
              await _getHotel(reserva[rowIndex].idHotel);
              Navigator.pushNamed(context, 'hotel', arguments: hotel);
            },
            child: Container(
              color: Color.fromARGB(255, 125, 94, 223),
              child: const Center(
                child: Icon(
                  Icons.hotel,
                  size: 29,
                ),
              ),
            ),
          );
        },
        columns: <GridColumn>[
          GridColumn(
            columnName: 'fecha fin',
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Fecha Inicio',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
            columnName: 'fecha Inicio',
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'fecha Fin',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
        source: ReservaDataSource(
          reservas: reservas,
        ),
      ),
    );
  }
}

class ReservaDataSource extends DataGridSource {
  ReservaDataSource({required List<Reserva> reservas}) {
    dataGridRows = reservas
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(
                columnName: 'fecha incio',
                value: dataGridRow.fecha_inicio.split('T')[0],
              ),
              DataGridCell<String>(
                columnName: 'fecha fin',
                value: dataGridRow.fecha_fin.split('T')[0],
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
