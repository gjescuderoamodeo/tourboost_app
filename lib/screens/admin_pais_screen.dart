import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tourboost_app/screens/screens.dart';
import 'package:tourboost_app/services/services.dart';
import 'package:tourboost_app/theme/app_theme.dart';

class AdminPaisScreen extends StatefulWidget {
  const AdminPaisScreen({super.key});

  @override
  State<AdminPaisScreen> createState() => _AdminPaisScreenState();
}

class _AdminPaisScreenState extends State<AdminPaisScreen> {
  //variable menú desplegable
  SampleItem? selectedMenu;

  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();

  final List<Map<String, dynamic>> data = [
    {
      "id": "1",
      "nombre": "zz",
    },
    {
      "id": "2",
      "nombre": "gg",
    }
  ];

  @override
  Widget build(BuildContext context) {
    final List<Pais> paises = data.map((paisData) {
      return Pais(
        id: paisData['id'],
        name: paisData['nombre'],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text("Administración paises"),
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
        //footer
        footerFrozenRowsCount: 1,
        footer: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Crear nuevo pais'),
                  content: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _nombreController,
                          decoration: InputDecoration(labelText: 'Nombre'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingrese el nombre';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final nuevoPais = {
                            'id': '23',
                            'nombre': _nombreController.text,
                          };
                          setState(() {
                            //print(nuevoPais);
                            data.add(nuevoPais);
                          });
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            color: AppTheme.secundary,
            child: const Center(
                child: Text(
              'Crear nuevo pais',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            )),
          ),
        ),
        //
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
              //Navigator.pushNamed(
              //    context, 'card'); // <----navegar a la página 'alert'
              print(data[rowIndex]['id']);
            },
            child: Container(
              color: const Color.fromARGB(255, 134, 139, 133),
              child: const Center(
                child: Icon(Icons.settings),
              ),
            ),
          );
        },
        columns: <GridColumn>[
          GridColumn(
            columnName: 'id',
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Id',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
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
        ],
        source: PaisDataSource(
          paises: paises,
        ),
      ),
    );
  }
}

class Pais {
  const Pais({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
}

class PaisDataSource extends DataGridSource {
  PaisDataSource({required List<Pais> paises}) {
    dataGridRows = paises
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(
                columnName: 'id',
                value: dataGridRow.id,
              ),
              DataGridCell<String>(
                columnName: 'nombre',
                value: dataGridRow.name,
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
