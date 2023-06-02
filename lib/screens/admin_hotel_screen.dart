import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tourboost_app/models/models.dart';
import 'package:tourboost_app/screens/home_screen.dart';
import 'package:tourboost_app/services/services.dart';
import 'package:tourboost_app/theme/app_theme.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

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
  final _idLugarController = TextEditingController();
  final _direccionController = TextEditingController();
  final _plazasController = TextEditingController();
  final _plazas2Controller = TextEditingController();
  final _telefonoController = TextEditingController();

  //obtener hoteles api
  List<Hotel> hoteles = [];

  Future<void> _getHoteles() async {
    final response =
        await http.get(Uri.parse('https://tour-boost-api.vercel.app/hotel'));

    //print(response.body);

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      hoteles = parsed.map<Hotel>((json) => Hotel.fromJson(json)).toList();
      setState(() {});
    } else {
      throw Exception('Failed to load hoteles');
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

  @override
  void initState() {
    super.initState();
    _getHoteles();
    _getLugares();
  }

  //función asincrona crear hotel
  void _crearHotel(int idLugar, int plazasTotales, String direccion,
      String telefono_contacto, String nombre) async {
    final nuevoHotel = {
      "idLugar": idLugar,
      "plazasTotales": plazasTotales,
      "plazasDisponibles": plazasTotales,
      "direccion": direccion,
      "telefono_contacto": telefono_contacto,
      "nombre": nombre
    };

    final response = await http.post(
      Uri.parse('https://tour-boost-api.vercel.app/hotel'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(nuevoHotel),
    );

    //toast de respuesta
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Hotel creado correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 168, 239, 4),
          textColor: Colors.white,
          fontSize: 16.0);
      _getHoteles(); //recargo la vista
    } else {
      Fluttertoast.showToast(
          msg: "Error al crear el Hotel",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 251, 0, 0),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  //

  //función asincrona modificar hotel
  void _modificarHotel(
      int idLugar,
      int idHotel,
      int plazasTotales,
      int plazasDisponibles,
      String direccion,
      String telefono_contacto,
      String nombre) async {
    final nuevoHotel = {
      "idLugar": idLugar,
      "idHotel": idHotel,
      "plazasTotales": plazasTotales,
      "plazasDisponibles": plazasDisponibles,
      "direccion": direccion,
      "telefono_contacto": telefono_contacto,
      "nombre": nombre
    };

    print(nuevoHotel);

    final response = await http.put(
      Uri.parse('https://tour-boost-api.vercel.app/hotel'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(nuevoHotel),
    );

    //toast de respuesta
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Hotel modificado correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 168, 239, 4),
          textColor: Colors.white,
          fontSize: 16.0);
      _getHoteles(); //recargo la vista
    } else {
      Fluttertoast.showToast(
          msg: "Error al modificar el Hotel",
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
  void _borrarHotel(int rowIndex) async {
    //nombre del hotel en función de la posición del array
    String nombre = hoteles[rowIndex].nombre;

    final body = {
      'nombre': nombre,
    };

    final response = await http.delete(
      Uri.parse('https://tour-boost-api.vercel.app/hotel'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    //toast de respuesta
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Hotel borrado correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 168, 239, 4),
          textColor: Colors.white,
          fontSize: 16.0);
      _getHoteles(); //recargo la vista
    } else {
      Fluttertoast.showToast(
          msg: "Error al borrar el Hotel",
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
  Widget build(BuildContext context) {
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
                  title: const Text('Crear nuevo hotel'),
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
                          controller: _direccionController,
                          decoration:
                              const InputDecoration(labelText: 'Dirección'),
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
                          decoration:
                              const InputDecoration(labelText: 'Plazas'),
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
                          decoration:
                              const InputDecoration(labelText: 'Teléfono'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingrese el teléfono';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        DropdownButtonFormField<String>(
                          value: _idLugarController.text.isNotEmpty
                              ? _idLugarController.text
                              : null,
                          items: lugares.map<DropdownMenuItem<String>>((lugar) {
                            return DropdownMenuItem<String>(
                              value: lugar.idLugar.toString(),
                              child: Text(lugar.nombre),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _idLugarController.text = value ?? '';
                            });
                          },
                          decoration: const InputDecoration(labelText: 'Lugar'),
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
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          /*final nuevoHotel = {
                            'id': 23,
                            'nombre': _nombreController.text,
                            'direccion': _direccionController.text,
                            'plazas': int.parse(_plazasController.text),
                            'telefono': _telefonoController.text,
                          };*/
                          setState(() {
                            //print(nuevoHotel);
                            //data.add(nuevoHotel);
                            _crearHotel(
                                int.parse(_idLugarController.text),
                                int.parse(_plazasController.text),
                                _direccionController.text,
                                _telefonoController.text,
                                _nombreController.text);

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
              _borrarHotel(rowIndex);
              setState(() {
                //data.removeAt(rowIndex);
              });
            },
            child: Container(
              color: Colors.redAccent,
              child: const Center(
                child: Icon(Icons.delete),
              ),
            ),
          );
        },
        //al desplazarse al otro lado
        startSwipeActionsBuilder:
            (BuildContext context, DataGridRow row, int rowIndex) {
          return GestureDetector(
            onTap: () {
              //print(data[rowIndex]['id']);
              _nombreController.text = hoteles[rowIndex].nombre;
              _direccionController.text = hoteles[rowIndex].direccion;
              _plazasController.text =
                  hoteles[rowIndex].plazasTotales.toString();
              _direccionController.text = hoteles[rowIndex].direccion;
              _telefonoController.text = hoteles[rowIndex].telefono_contacto;
              _plazas2Controller.text =
                  hoteles[rowIndex].plazasDisponibles.toString();

              //caja de texto para modificar el hotel
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('modificar hotel'),
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
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _direccionController,
                              decoration:
                                  const InputDecoration(labelText: 'Dirección'),
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
                              decoration: const InputDecoration(
                                  labelText: 'Plazas Totales'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Por favor, ingrese el número de plazas totales';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _plazas2Controller,
                              decoration: const InputDecoration(
                                  labelText: 'Plazas Disponibles'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Por favor, ingrese el número de plazas disponibles';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _telefonoController,
                              decoration:
                                  const InputDecoration(labelText: 'Teléfono'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Por favor, ingrese el teléfono';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            DropdownButtonFormField<String>(
                              value: _idLugarController.text.isNotEmpty
                                  ? _idLugarController.text
                                  : null,
                              items: lugares
                                  .map<DropdownMenuItem<String>>((lugar) {
                                return DropdownMenuItem<String>(
                                  value: lugar.idLugar.toString(),
                                  child: Text(lugar.nombre),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _idLugarController.text = value ?? '';
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
                            style: TextStyle(color: Colors.red, fontSize: 15),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _modificarHotel(
                                  int.parse(_idLugarController.text),
                                  hoteles[rowIndex].idHotel,
                                  int.parse(_plazasController.text),
                                  int.parse(_plazas2Controller.text),
                                  _direccionController.text,
                                  _telefonoController.text,
                                  _nombreController.text);

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
        //columnas de la tabla
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

class HotelDataSource extends DataGridSource {
  HotelDataSource({required List<Hotel> hoteles}) {
    dataGridRows = hoteles
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(
                columnName: 'nombre',
                value: dataGridRow.nombre,
              ),
              DataGridCell<String>(
                columnName: 'direccion',
                value: dataGridRow.direccion,
              ),
              DataGridCell<int>(
                columnName: 'plazas',
                value: dataGridRow.plazasTotales,
              ),
              DataGridCell<String>(
                columnName: 'telefono',
                value: dataGridRow.telefono_contacto,
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
