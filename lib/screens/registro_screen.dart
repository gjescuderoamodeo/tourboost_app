import 'package:flutter/material.dart';
import 'package:tourboost_app/widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class RegistroScreen extends StatelessWidget {
  RegistroScreen({super.key});

  final Map<String, String> formValues = {
    'nombre': '',
    'apellidos': '',
    'password': '',
    'correo': ''
  };

  //validador email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su correo electrónico';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor ingrese un correo electrónico válido';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro usuario'),
      ),
      body: Center(
        child: Form(
          key: myFormKey,
          child: Column(children: [
            //nombre
            const SizedBox(height: 30),
            CustomInputField(
              labelText: 'Nombre',
              hintText: "nombre usuario",
              formProperty: 'nombre',
              formValues: formValues,
            ),
            const SizedBox(height: 20),
            //apellidos
            CustomInputField(
              labelText: 'apellidos',
              hintText: "apellidos usuario",
              formProperty: 'apellidos',
              formValues: formValues,
            ),
            const SizedBox(height: 20),
            //email
            CustomInputField(
              labelText: 'Email',
              hintText: "correo usuario",
              formProperty: 'correo',
              keyboardType: TextInputType.emailAddress,
              formValues: formValues,
              validator: validateEmail,
            ),
            const SizedBox(height: 20),
            //contraseña
            CustomInputField(
              labelText: 'Contraseña',
              hintText: "contraseña usuario",
              obscureText: true,
              formProperty: 'password',
              formValues: formValues,
            ),
            const SizedBox(height: 20),
            //botón form
            ElevatedButton(
              child: const SizedBox(
                child: Center(child: Text("guardar")),
                width: double.infinity,
              ),  
              onPressed: () async {
                //quitar teclado (movil)
                FocusScope.of(context).requestFocus(FocusNode());

                //! para confiar que siempre le voy a mandar algo
                if (!myFormKey.currentState!.validate()) {
                  Fluttertoast.showToast(
                      msg: "Formulario no válido",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      backgroundColor: const Color.fromARGB(255, 239, 4, 4),
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return;
                } else {
                  //le envio los datos por post a la api
                  final url =
                      Uri.parse('https://tour-boost-api.vercel.app/usuario');
                  final response = await http.post(
                    url,
                    headers: {"Content-Type": "application/json"},
                    body: jsonEncode({
                      'nombre': formValues['nombre']!,
                      'apellidos': formValues['apellidos']!,
                      'password': formValues['password']!,
                      'correo': formValues['correo']!,
                    }),
                  );

                  // Verificar la respuesta del servidor
                  if (response.statusCode == 200) {
                    Fluttertoast.showToast(
                      msg: "Usuario creado correctamente",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      backgroundColor: const Color.fromARGB(255, 168, 239, 4),
                      textColor: Colors.white,
                      fontSize: 16.0);
                  }else if(response.statusCode==409){
                    Fluttertoast.showToast(
                      msg: "Ese correo ya existe",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                      textColor: const Color.fromARGB(255, 3, 3, 3),
                      fontSize: 16.0);
                  }else {
                    Fluttertoast.showToast(
                      msg: "Error al crear el usuario",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      backgroundColor: const Color.fromARGB(255, 251, 0, 0),
                      textColor: Colors.white,
                      fontSize: 16.0);
                  }
                }
              },
            )
          ]),
        ),
      ),
    );
  }
}
