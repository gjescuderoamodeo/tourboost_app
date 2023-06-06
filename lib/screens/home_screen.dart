import 'package:flutter/material.dart';
import 'package:tourboost_app/screens/screens.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

enum SampleItem { itemOne, itemThree }

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //variable menú desplegable
  SampleItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text("TourBoost"),
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
      body: Stack(
        children: [
          // Background
          Background(),
          // Home Body
          _HomeBody()
        ],
      ),
      //bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Titulos
          PageTitle(),
          // Card Table
          CardTable(),
        ],
      ),
    );
  }
}
