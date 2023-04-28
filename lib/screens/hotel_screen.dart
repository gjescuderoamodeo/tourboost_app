import 'package:flutter/material.dart';
import 'package:tourboost_app/screens/screens.dart';
import 'package:tourboost_app/services/services.dart';

class HotelScreen extends StatefulWidget {
  const HotelScreen({super.key});

  //Text('Nombre del hotel: ${datos["nombre"]}'),

  @override
  State<HotelScreen> createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  //rango fecha
  DateTimeRange? _selectedRange;

//cuadro dialogo elegir fecha
  Future<void> _presentDateRangePicker(BuildContext context) async {
    //rango inicial
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now(),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      saveText: "Reservar hotel",
      helpText: "Elige fecha inicio fin",
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _selectedRange ?? initialDateRange,
    );
    if (newDateRange == null) {
      return;
    }
    setState(() {
      _selectedRange = newDateRange;
    });

    //se ejecuta al darle a guardar
    print('La fecha seleccionada es $_selectedRange');
  }
//

  @override
  Widget build(BuildContext context) {
    //variable menú desplegable
    SampleItem? selectedMenu;

    //datos pasados de hoteles screen
    final datos =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(datos["nombre"]),
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
      body: ListView(
        children: [
          ListTile(
            title: const Text(
              'Crear Reserva',
              style: TextStyle(fontSize: 20),
            ),
            trailing: const Icon(Icons.add),
            onTap: () {
              //reservas alert
              _presentDateRangePicker(context);
            },
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
          ListTile(
            title: const Text(
              'Ver en el Mapa',
              style: TextStyle(fontSize: 20),
            ),
            trailing: const Icon(Icons.map),
            onTap: () {
              //mapa screen
            },
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
        ],
      ),
    );
  }
}
