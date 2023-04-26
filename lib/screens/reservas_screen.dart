import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tourboost_app/screens/screens.dart';
import 'package:tourboost_app/services/services.dart';
import 'package:tourboost_app/theme/app_theme.dart';

class ReservasScreen extends StatefulWidget {
  const ReservasScreen({super.key});

  @override
  State<ReservasScreen> createState() => _ReservasScreenState();
}

class _ReservasScreenState extends State<ReservasScreen> {
  //variable menú desplegable
  SampleItem? selectedMenu;

  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();

  final List<Map<String, dynamic>> data = [
    {
      "fecha Inicio": "22-22-22",
      "fecha fin": "33-33-33",
    },
    {
      "fecha Inicio": "2",
      "fecha fin": "gg",
    }
  ];

  @override
  Widget build(BuildContext context) {
    final List<Reserva> reservaes = data.map((reservaData) {
      return Reserva(
        fechaInicio: reservaData['fecha Inicio'],
        fechaFin: reservaData['fecha fin'],
      );
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
                data.removeAt(rowIndex);
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
              print(data[rowIndex]['fecha Inicio']);
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
          reservaes: reservaes,
        ),
      ),
    );
  }
}

class Reserva {
  const Reserva({
    required this.fechaInicio,
    required this.fechaFin,
  });

  final String fechaInicio;
  final String fechaFin;
}

class ReservaDataSource extends DataGridSource {
  ReservaDataSource({required List<Reserva> reservaes}) {
    dataGridRows = reservaes
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(
                columnName: 'fecha incio',
                value: dataGridRow.fechaInicio,
              ),
              DataGridCell<String>(
                columnName: 'fecha fin',
                value: dataGridRow.fechaFin,
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
