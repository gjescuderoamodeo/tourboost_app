import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tourboost_app/screens/screens.dart';
import 'package:tourboost_app/services/services.dart';
import 'package:tourboost_app/theme/app_theme.dart';

class AdminMarcadoresScreen extends StatefulWidget {
  const AdminMarcadoresScreen({super.key});

  @override
  State<AdminMarcadoresScreen> createState() => _AdminMarcadoresScreenState();
}

class _AdminMarcadoresScreenState extends State<AdminMarcadoresScreen> {
  //variable menú desplegable
  SampleItem? selectedMenu;

  final _formKey = GlobalKey<FormState>();
  final _latitudController = TextEditingController();
  final _longitudController = TextEditingController();
  final _tipolugarController = TextEditingController();
  final _nombreController = TextEditingController();
  final _paisController = TextEditingController();

  final List<Map<String, dynamic>> data = [
    {
      "latitud": "pp",
      "longitud": "Direccion 1",
      "tipo_lugar": "playa",
      "nombre": "rrrr",
      "pais": "España"
    },
    {
      "latitud": "test",
      "longitud": "Direccion 2",
      "tipo_lugar": "bosque",
      "nombre": "eeee",
      "pais": "España"
    }
  ];

  @override
  Widget build(BuildContext context) {
    final List<Lugar2> lugares = data.map((lugarData) {
      return Lugar2(
        latitud: lugarData['latitud'],
        longitud: lugarData['longitud'],
        tipo_lugar: lugarData['tipo_lugar'],
        nombre: lugarData['nombre'],
        pais: lugarData['pais'],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text("Administración lugares"),
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
                  title: Text('Crear nuevo lugar'),
                  content: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _latitudController,
                          decoration: InputDecoration(labelText: 'latitud'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingrese latitud';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _longitudController,
                          decoration: InputDecoration(labelText: 'longitud'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingrese longitud';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _tipolugarController,
                          decoration: InputDecoration(labelText: 'tipo_lugar'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingrese el tipo_lugar';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _nombreController,
                          decoration: InputDecoration(labelText: 'nombre'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingrese el nombre';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _nombreController,
                          decoration: InputDecoration(labelText: 'nombre'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingrese el nombre';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _paisController,
                          decoration: InputDecoration(labelText: 'pais'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingrese el pais';
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
                          final nuevolugar = {
                            'latitud': _latitudController.text,
                            'longitud': _longitudController.text,
                            'nombre': _nombreController.text,
                            'tipo_lugar': _tipolugarController.text,
                            'pais': _paisController.text,
                          };
                          setState(() {
                            //print(nuevolugar);
                            data.add(nuevolugar);
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
              'Crear nuevo lugar',
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
            columnName: 'latitud',
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Latitud',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
            columnName: 'longitud',
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Longitud',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
            columnName: 'tipo_lugar',
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Tipo Lugar2',
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
          GridColumn(
            columnName: 'pais',
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
        source: lugarDataSource(
          lugares: lugares,
        ),
      ),
    );
  }
}

class Lugar2 {
  const Lugar2(
      {required this.latitud,
      required this.longitud,
      required this.tipo_lugar,
      required this.nombre,
      required this.pais});

  final String latitud;
  final String longitud;
  final String tipo_lugar;
  final String nombre;
  final String pais;
}

class lugarDataSource extends DataGridSource {
  lugarDataSource({required List<Lugar2> lugares}) {
    dataGridRows = lugares
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(
                columnName: 'latitud',
                value: dataGridRow.latitud,
              ),
              DataGridCell<String>(
                columnName: 'longitud',
                value: dataGridRow.longitud,
              ),
              DataGridCell<String>(
                columnName: 'tipo_lugar',
                value: dataGridRow.tipo_lugar,
              ),
              DataGridCell<String>(
                columnName: 'nombre',
                value: dataGridRow.nombre,
              ),
              DataGridCell<String>(
                columnName: 'pais',
                value: dataGridRow.pais,
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
