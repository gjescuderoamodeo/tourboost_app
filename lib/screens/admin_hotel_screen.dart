import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tourboost_app/screens/screens.dart';
import 'package:tourboost_app/services/services.dart';
import 'package:tourboost_app/theme/app_theme.dart';

class AdminHotelScreen extends StatefulWidget {
  const AdminHotelScreen({super.key});

  @override
  State<AdminHotelScreen> createState() => _AdminHotelScreenState();
}

class _AdminHotelScreenState extends State<AdminHotelScreen> {
  //variable menú desplegable
  SampleItem? selectedMenu;

  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _direccionController = TextEditingController();
  final _plazasController = TextEditingController();
  final _telefonoController = TextEditingController();

  final List<Map<String, dynamic>> data = [
    {
      "id": 1,
      "nombre": "pp",
      "direccion": "Direccion 1",
      "plazas": 33,
      "telefono": "222-333-444-555"
    },
    {
      "id": 2,
      "nombre": "test",
      "direccion": "Direccion 2",
      "plazas": 333,
      "telefono": "222-333-444-555"
    }
  ];

  @override
  Widget build(BuildContext context) {
    final List<Hotel> hoteles = data.map((hotelData) {
      return Hotel(
        id: hotelData['id'],
        name: hotelData['nombre'],
        direccion: hotelData['direccion'],
        plazas: hotelData['plazas'],
        telefono: hotelData['telefono'],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text("Administración hoteles"),
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
                  title: Text('Crear nuevo hotel'),
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
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _direccionController,
                          decoration: InputDecoration(labelText: 'Dirección'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingrese la dirección';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _plazasController,
                          decoration: InputDecoration(labelText: 'Plazas'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingrese el número de plazas';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _telefonoController,
                          decoration: InputDecoration(labelText: 'Teléfono'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingrese el teléfono';
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
                          final nuevoHotel = {
                            'id': 23,
                            'nombre': _nombreController.text,
                            'direccion': _direccionController.text,
                            'plazas': int.parse(_plazasController.text),
                            'telefono': _telefonoController.text,
                          };
                          setState(() {
                            //print(nuevoHotel);
                            data.add(nuevoHotel);
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
              'Crear nuevo hotel',
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
            columnName: 'direccion',
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Direccion',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
            columnName: 'plazastotales',
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Plazas totales',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
            columnName: 'telefono',
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Telefono contacto',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
        source: HotelDataSource(
          hoteles: hoteles,
        ),
      ),
    );
  }
}

class Hotel {
  const Hotel(
      {required this.id,
      required this.name,
      required this.direccion,
      required this.plazas,
      required this.telefono});

  final int id;
  final String name;
  final String direccion;
  final int plazas;
  final String telefono;
}

class HotelDataSource extends DataGridSource {
  HotelDataSource({required List<Hotel> hoteles}) {
    dataGridRows = hoteles
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(
                columnName: 'nombre',
                value: dataGridRow.name,
              ),
              DataGridCell<String>(
                columnName: 'direccion',
                value: dataGridRow.direccion,
              ),
              DataGridCell<int>(
                columnName: 'plazas',
                value: dataGridRow.plazas,
              ),
              DataGridCell<String>(
                columnName: 'telefono',
                value: dataGridRow.telefono,
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
