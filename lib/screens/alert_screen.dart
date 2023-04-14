import 'package:flutter/material.dart';

class AlertScreen extends StatelessWidget {
  void displayDialog(BuildContext context) {
    showDialog(
        //cerrar dialogo hacer click en la sombra
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: const Text("alerta"),
            content: Column(
                //tamaño minimo
                mainAxisSize: MainAxisSize.min,
                children: const [Text("Contenido alerta")]),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("cancelar"))
            ],
          );
        });
  }

  const AlertScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          //style: ElevatedButton.styleFrom(primary: Colors.indigo),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'mostrar alerta',
              style: TextStyle(fontSize: 20),
            ),
          ),
          onPressed: () {
            displayDialog(context);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.cake_sharp),
        onPressed: () {
          //regresa a la pantalla anterior
          Navigator.pop(context);
        },
      ),
    );
  }
}
