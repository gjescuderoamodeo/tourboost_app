import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tourboost_app/screens/screens.dart';
import 'package:tourboost_app/services/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tourboost_app/theme/app_theme.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ffi';
import '../models/models.dart';

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
  String _nombreOriginal = "";
  final _codigoController = TextEditingController();

  //obtener paises api
  List<Pais> paises = [];

  Future<void> _getPais() async {
    final response =
        await http.get(Uri.parse('https://tour-boost-api.vercel.app/pais'));

    //print(response.body);

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      paises = parsed.map<Pais>((json) => Pais.fromJson(json)).toList();
      setState(() {});
    } else {
      throw Exception('Failed to load Pais');
    }
  }

  //función asincrona crear pais
  void crearPais(String nombre, String codigopais) async {
    final nuevoPais = {"nombre": nombre, "codigo_pais": codigopais};

    final response = await http.post(
      Uri.parse('https://tour-boost-api.vercel.app/pais'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(nuevoPais),
    );

    //toast de respuesta
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Pais creado correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 168, 239, 4),
          textColor: Colors.white,
          fontSize: 16.0);
      _getPais();
    } else {
      Fluttertoast.showToast(
          msg: "Error al crear el Pais",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 251, 0, 0),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  //

  //función asincrona modificar pais
  void _modificarPais(
      String codigopais, String nombre_nuevo, String nombre) async {
    final nuevoPais = {
      "nombre": nombre,
      "codigo_pais": codigopais,
      "nombre_nuevo": nombre_nuevo
    };

    print(nuevoPais);

    final response = await http.put(
      Uri.parse('https://tour-boost-api.vercel.app/pais'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(nuevoPais),
    );

    //toast de respuesta
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Pais modificado correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 168, 239, 4),
          textColor: Colors.white,
          fontSize: 16.0);
      _getPais(); //recargo la vista
    } else {
      Fluttertoast.showToast(
          msg: "Error al modificar el Pais",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 251, 0, 0),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  //

  //función asincrona borrar hotel
  void _borrarPais(int rowIndex) async {
    //nombre del hotel en función de la posición del array
    String nombre = paises[rowIndex].nombre;

    final body = {
      'nombre': nombre,
    };

    final response = await http.delete(
      Uri.parse('https://tour-boost-api.vercel.app/pais'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    //toast de respuesta
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Pais borrado correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 168, 239, 4),
          textColor: Colors.white,
          fontSize: 16.0);
      _getPais(); //recargo la vista
    } else {
      Fluttertoast.showToast(
          msg: "Error al borrar el Pais",
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
    _getPais();
  }

  @override
  Widget build(BuildContext context) {
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
                    Navigator.pushNamed(context, 'configuraciones');
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
                  content: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _nombreController,
                            decoration:
                                const InputDecoration(labelText: 'Nombre'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor, ingrese el nombre';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _codigoController,
                            decoration:
                                const InputDecoration(labelText: 'Codigo pais'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor, ingrese el codigo';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            //print(nuevoPais);
                            //data.add(nuevoPais);
                            crearPais(
                                _nombreController.text, _codigoController.text);
                          });

                          //quitar el alert dialog
                          Navigator.pop(context);
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
              _borrarPais(rowIndex);
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
              _nombreController.text = paises[rowIndex].nombre;
              _nombreOriginal = paises[rowIndex].nombre;
              _codigoController.text = paises[rowIndex].codigo_pais;

              //caja de texto para modificar el pais
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('modificar pais'),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _nombreController,
                            decoration:
                                const InputDecoration(labelText: 'Nombre'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor, ingrese el nombre';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _codigoController,
                            decoration:
                                const InputDecoration(labelText: 'Codigo Pais'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor, ingrese el código del pais';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Center(
                          child: Text(
                            'Modificar',
                            style: TextStyle(color: Colors.red, fontSize: 15),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _modificarPais(_codigoController.text,
                                  _nombreController.text, _nombreOriginal);

                              //quitar el alert dialog
                              Navigator.pop(context);
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
                'Nombre pais',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
            columnName: 'codigo_pais',
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Código pais',
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

class PaisDataSource extends DataGridSource {
  PaisDataSource({required List<Pais> paises}) {
    dataGridRows = paises
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(
                columnName: 'nombre',
                value: dataGridRow.nombre,
              ),
              DataGridCell<String>(
                columnName: 'codigo_pais',
                value: dataGridRow.codigo_pais,
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
