import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tourboost_app/models/models.dart';
import 'package:tourboost_app/screens/screens.dart';
import 'package:tourboost_app/services/services.dart';
import 'package:tourboost_app/theme/app_theme.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

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

  //obtener lugares api
  List<Lugar> lugares = [];

  Future<void> _getLugares() async {
    final response =
        await http.get(Uri.parse('https://tour-boost-api.vercel.app/lugar'));

    //print(response.body);

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      lugares = parsed.map<Lugar>((json) => Lugar.fromJson(json)).toList();
      setState(() {});
    } else {
      throw Exception('Failed to load lugares');
    }
  }

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

  //función asincrona modificar lugar
  void _modificar_lugar(
    double latitud,
    double longitud,
    String tipolugar,
    String nombre,
    String pais,
    int idLugar,
  ) async {
    final nuevoLugar = {
      "latitud": latitud,
      "longitud": longitud,
      "tipolugar": tipolugar,
      "nombre": nombre,
      "nombrePais": pais,
      "idLugar": idLugar
    };

    final response = await http.put(
      Uri.parse('https://tour-boost-api.vercel.app/lugar'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(nuevoLugar),
    );

    //toast de respuesta
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Lugar modificado correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 168, 239, 4),
          textColor: Colors.white,
          fontSize: 16.0);
      _getLugares(); //recargo la vista
    } else {
      Fluttertoast.showToast(
          msg: "Error al modificar el Lugar",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 251, 0, 0),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  //

  //función asincrona borrar lugar
  void _borrarLugar(int rowIndex) async {
    //nombre del hotel en función de la posición del array
    int idLugar = lugares[rowIndex].idLugar;

    final body = {
      'idLugar': idLugar,
    };

    final response = await http.delete(
      Uri.parse('https://tour-boost-api.vercel.app/lugar'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    //toast de respuesta
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Lugar borrado correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 168, 239, 4),
          textColor: Colors.white,
          fontSize: 16.0);
      _getLugares(); //recargo la vista
    } else {
      Fluttertoast.showToast(
          msg: "Error al borrar el Lugar",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 251, 0, 0),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  //

  //función asincrona crear pais
  void _crearLugar(Map<String, Object> nuevoLugar) async {
    print(nuevoLugar);
    final response = await http.post(
      Uri.parse('https://tour-boost-api.vercel.app/lugar'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(nuevoLugar),
    );

    //toast de respuesta
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Lugar creado correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 168, 239, 4),
          textColor: Colors.white,
          fontSize: 16.0);
      _getLugares();
    } else {
      Fluttertoast.showToast(
          msg: "Error al crear el Lugar",
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
    _getLugares();
    _getPais();
  }

  @override
  Widget build(BuildContext context) {
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
                  content: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _latitudController,
                            decoration: InputDecoration(labelText: 'latitud'),
                            keyboardType: TextInputType.number,
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
                            keyboardType: TextInputType.number,
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
                            decoration:
                                InputDecoration(labelText: 'tipo_lugar'),
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
                          DropdownButtonFormField<String>(
                            value: _paisController.text.isNotEmpty
                                ? _paisController.text
                                : null,
                            items: paises.map<DropdownMenuItem<String>>((pais) {
                              return DropdownMenuItem<String>(
                                value: pais.nombre,
                                child: Text(pais.nombre),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _paisController.text = value ?? '';
                              });
                            },
                            decoration:
                                const InputDecoration(labelText: 'Pais'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, seleccione un pais';
                              }
                              return null;
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final nuevolugar = {
                            'latitud': double.parse(_latitudController.text),
                            'longitud': double.parse(_longitudController.text),
                            'nombre': _nombreController.text,
                            'tipo_lugar': _tipolugarController.text,
                            'nombrePais': _paisController.text,
                          };

                          _crearLugar(nuevolugar);
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
              _borrarLugar(rowIndex);
            },
            child: Container(
              color: AppTheme.deleteButton, // <---- cambia el color a rojo
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
              _nombreController.text = lugares[rowIndex].nombre;
              _latitudController.text = lugares[rowIndex].latitud.toString();
              _longitudController.text = lugares[rowIndex].longitud.toString();
              _tipolugarController.text = lugares[rowIndex].tipoLugar;
              _paisController.text = lugares[rowIndex].nombrePais;

              //caja de texto para modificar el pais
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('modificar pais'),
                    content: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: _latitudController,
                              decoration: InputDecoration(labelText: 'latitud'),
                              keyboardType: TextInputType.number,
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
                              decoration:
                                  InputDecoration(labelText: 'longitud'),
                              keyboardType: TextInputType.number,
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
                              decoration:
                                  InputDecoration(labelText: 'tipo_lugar'),
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
                            DropdownButtonFormField<String>(
                              value: _paisController.text.isNotEmpty
                                  ? _paisController.text
                                  : null,
                              items:
                                  paises.map<DropdownMenuItem<String>>((pais) {
                                return DropdownMenuItem<String>(
                                  value: pais.nombre,
                                  child: Text(pais.nombre),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _paisController.text = value ?? '';
                                });
                              },
                              decoration:
                                  const InputDecoration(labelText: 'Pais'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, seleccione un pais';
                                }
                                return null;
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Center(
                          child: Text(
                            'Modificar',
                            style: TextStyle(color: AppTheme.alert, fontSize: 15),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _modificar_lugar(
                                double.parse(_latitudController.text),
                                double.parse(_longitudController.text),
                                _tipolugarController.text,
                                _nombreController.text,
                                _paisController.text,
                                lugares[rowIndex].idLugar,
                              );

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
              color: AppTheme.settingsButton,
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
                'Tipo Lugar',
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

class lugarDataSource extends DataGridSource {
  lugarDataSource({required List<Lugar> lugares}) {
    dataGridRows = lugares
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<double>(
                columnName: 'latitud',
                value: dataGridRow.latitud,
              ),
              DataGridCell<double>(
                columnName: 'longitud',
                value: dataGridRow.longitud,
              ),
              DataGridCell<String>(
                columnName: 'tipo_lugar',
                value: dataGridRow.tipoLugar,
              ),
              DataGridCell<String>(
                columnName: 'nombre',
                value: dataGridRow.nombre,
              ),
              DataGridCell<String>(
                columnName: 'pais',
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
