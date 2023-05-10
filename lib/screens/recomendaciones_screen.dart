import 'package:flutter/material.dart';
import 'package:tourboost_app/services/services.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

class RecomendacionScreen extends StatefulWidget {
  RecomendacionScreen({Key? key}) : super(key: key);

  @override
  State<RecomendacionScreen> createState() => _RecomendacionScreenState();
}

class _RecomendacionScreenState extends State<RecomendacionScreen> {
  //variable menú desplegable
  SampleItem4? selectedMenu;

  @override
  Widget build(BuildContext context) {
    //datos pasados de hoteles screen
    String datos = ModalRoute.of(context)!.settings.arguments.toString();

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text("Recomendación "),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: CircleAvatar(
              child: PopupMenuButton<SampleItem4>(
                initialValue: selectedMenu,
                onSelected: (SampleItem4 item) {
                  setState(() {
                    selectedMenu = item;
                  });

                  //navegar a la pantalla de Configuración
                  if (item == SampleItem4.itemOne) {
                    Navigator.pushNamed(context, 'configuracion');
                  }
                  //logout
                  if (item == SampleItem4.itemThree) {
                    final AuthService authService = AuthService();
                    authService.logout();

                    Navigator.pushNamed(context, 'login');
                  }
                },
                icon: const Icon(Icons.person),
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<SampleItem4>>[
                  PopupMenuItem<SampleItem4>(
                    value: SampleItem4.itemOne,
                    child: Row(
                      children: const [
                        Text('Configuración'),
                        SizedBox(width: 20),
                        Icon(Icons.build_rounded, color: Colors.black)
                      ],
                    ),
                  ),
                  const PopupMenuItem<SampleItem4>(
                    value: SampleItem4.itemTwo,
                    child: Text('Item 2'),
                  ),
                  PopupMenuItem<SampleItem4>(
                    value: SampleItem4.itemThree,
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          CustomCardType(
            imageUrl:
                "https://th.bing.com/th/id/OIP.YwUr61ty6Ne_Ijl-Kn-9sQHaFH?pid=ImgDet&rs=1",
            mensaje: datos,
          ),
          CustomCardType(
            imageUrl:
                "https://3.bp.blogspot.com/-3xHYPis5oL4/V5x6LFTm4hI/AAAAAAAAEzI/0MgJwBVeew457ImK31YPg_-EAnCdmfYUQCLcB/s1600/Arma%2B3%2Bss1.jpg",
            mensaje: 'Arma III',
          )
        ],
      ),
    );
  }
}
