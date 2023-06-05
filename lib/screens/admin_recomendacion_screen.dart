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

class AdminRecomendacionScreen extends StatefulWidget {
  const AdminRecomendacionScreen({super.key});

  @override
  State<AdminRecomendacionScreen> createState() =>
      _AdminRecomendacionScreenState();
}

class _AdminRecomendacionScreenState extends State<AdminRecomendacionScreen> {
  //variable menú desplegable
  SampleItem? selectedMenu;

  final _formKey = GlobalKey<FormState>();
  final _imagenController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _nombreController = TextEditingController();
  final _lugarController = TextEditingController();

  //obtener recomendaciones api
  List<Recomendacion> recomendaciones = [];

  Future<void> _getrecomendaciones() async {
    final response = await http
        .get(Uri.parse('https://tour-boost-api.vercel.app/recomendacion'));

    //print(response.body);

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      recomendaciones = parsed
          .map<Recomendacion>((json) => Recomendacion.fromJson(json))
          .toList();
      setState(() {});
    } else {
      throw Exception('Failed to load recomendaciones');
    }
  }

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

  //función asincrona modificar recomendacion
  void _modificar_recomendacion(
    String imagen,
    String descripcion,
    String nombre,
    String lugar,
    int idRecomendacion,
  ) async {
    final nuevorecomendacion = {
      "imagen": imagen,
      "descripcion": descripcion,
      "nombre": nombre,
      "nombrePais": lugar,
      "idRecomendacion": idRecomendacion
    };

    final response = await http.put(
      Uri.parse('https://tour-boost-api.vercel.app/recomendacion'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(nuevorecomendacion),
    );

    //toast de respuesta
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "recomendacion modificado correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 168, 239, 4),
          textColor: Colors.white,
          fontSize: 16.0);
      _getrecomendaciones(); //recargo la vista
    } else {
      Fluttertoast.showToast(
          msg: "Error al modificar la recomendacion",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 251, 0, 0),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  //

  //función asincrona borrar recomendacion
  void _borrarrecomendacion(int rowIndex) async {
    //nombre del hotel en función de la posición del array
    int idRecomendacion = recomendaciones[rowIndex].idRecomendacion;

    final body = {
      'idRecomendacion': idRecomendacion,
    };

    final response = await http.delete(
      Uri.parse('https://tour-boost-api.vercel.app/recomendacion'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    //toast de respuesta
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "recomendacion borrado correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 168, 239, 4),
          textColor: Colors.white,
          fontSize: 16.0);
      _getrecomendaciones(); //recargo la vista
    } else {
      Fluttertoast.showToast(
          msg: "Error al borrar el recomendacion",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 251, 0, 0),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  //

  //función asincrona crear lugar
  void _crearrecomendacion(Map<String, Object> nuevorecomendacion) async {
    final response = await http.post(
      Uri.parse('https://tour-boost-api.vercel.app/recomendacion'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(nuevorecomendacion),
    );

    //toast de respuesta
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "recomendacion creado correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 168, 239, 4),
          textColor: Colors.white,
          fontSize: 16.0);
      _getrecomendaciones();
    } else {
      Fluttertoast.showToast(
          msg: "Error al crear el recomendacion",
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
    _getrecomendaciones();
    _getLugares();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text("Administración recomendaciones",
            style: TextStyle(fontSize: 13)),
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
            _nombreController.text = "";
            _imagenController.text = "";
            _descripcionController.text = "";
            _lugarController.text = "";

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Crear nueva recomendacion'),
                  content: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _imagenController,
                            decoration: InputDecoration(labelText: 'imagen'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor, ingrese imagen';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _descripcionController,
                            decoration: InputDecoration(
                                labelText: 'tipo_recomendacion'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor, ingrese el tipo_recomendacion';
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
                            value: _lugarController.text.isNotEmpty
                                ? _lugarController.text
                                : null,
                            items:
                                lugares.map<DropdownMenuItem<String>>((lugar) {
                              return DropdownMenuItem<String>(
                                value: lugar.nombre,
                                child: Text(lugar.nombre),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _lugarController.text = value ?? '';
                              });
                            },
                            decoration:
                                const InputDecoration(labelText: 'Lugar'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, seleccione un lugar';
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
                          int idLugar = 1;
                          for (var lugar in lugares) {
                            if (lugar.nombre == _lugarController.text) {
                              idLugar = lugar.idLugar;
                            }
                          }

                          final nuevorecomendacion = {
                            'imagen': _imagenController.text,
                            'descripcion': _descripcionController.text,
                            'nombre': _nombreController.text,
                            'idLugar': idLugar,
                          };

                          _crearrecomendacion(nuevorecomendacion);
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
              'Crear nueva recomendacion',
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
              _borrarrecomendacion(rowIndex);
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
              _nombreController.text = recomendaciones[rowIndex].nombre;
              _imagenController.text = recomendaciones[rowIndex].imagen;
              _descripcionController.text =
                  recomendaciones[rowIndex].descripcion;

              //
              String lugarN = "";
              for (Lugar lugar in lugares) {
                if (lugar.idLugar == recomendaciones[rowIndex].idLugar) {
                  lugarN = lugar.nombre;
                  break;
                }
              }

              _lugarController.text = lugarN;

              //caja de texto para modificar recomendacion
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('modificar recomendacion'),
                    content: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: _imagenController,
                              decoration: InputDecoration(labelText: 'imagen'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Por favor, ingrese imagen';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _descripcionController,
                              decoration:
                                  InputDecoration(labelText: 'descripcion'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Por favor, ingrese descripcion';
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
                              value: _lugarController.text.isNotEmpty
                                  ? _lugarController.text
                                  : null,
                              items: lugares
                                  .map<DropdownMenuItem<String>>((lugar) {
                                return DropdownMenuItem<String>(
                                  value: lugar.nombre,
                                  child: Text(lugar.nombre),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _lugarController.text = value ?? '';
                                });
                              },
                              decoration:
                                  const InputDecoration(labelText: 'Lugar'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, seleccione un lugar';
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
                              _modificar_recomendacion(
                                _imagenController.text,
                                _descripcionController.text,
                                _nombreController.text,
                                _lugarController.text,
                                recomendaciones[rowIndex].idRecomendacion,
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
            columnName: 'imagen',
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                ' Url Imagen',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
            columnName: 'descripcion',
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Descripcion',
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
        source: recomendacionDataSource(
          recomendaciones: recomendaciones,
        ),
      ),
    );
  }
}

class recomendacionDataSource extends DataGridSource {
  recomendacionDataSource({required List<Recomendacion> recomendaciones}) {
    dataGridRows = recomendaciones
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(
                columnName: 'imagen',
                value: dataGridRow.imagen,
              ),
              DataGridCell<String>(
                columnName: 'descripcion',
                value: dataGridRow.descripcion,
              ),
              DataGridCell<String>(
                columnName: 'nombre',
                value: dataGridRow.nombre,
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
