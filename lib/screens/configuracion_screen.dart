import 'package:flutter/material.dart';
import 'package:tourboost_app/models/models.dart';
import 'package:tourboost_app/services/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/widgets.dart';

void main() => runApp(const ConfiguracionScreen());

class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text('Configuraciones usuario'),
      ),
      body: Stack(
        children: [
          // Background
          Background(),
          // Home Body
          _ConfBody()
        ],
      ),
    );
  }
}

class _ConfBody extends StatefulWidget {
  @override
  State<_ConfBody> createState() => _ConfBodyState();
}

late int _idUser;
//función obtener id usuario
Future<void> _getUserId() async {
  final AuthService authService = AuthService();

  //obtener token
  final token = await authService.readToken();
  final userId = authService.getUserIdFromToken(token);

  _idUser = userId;
}

//obtener usuario api
Future<void> _getusuario() async {
  final response = await http
      .get(Uri.parse('https://tour-boost-api.vercel.app/usuario/$_idUser'));

  //print(response.body);

  if (response.statusCode == 200) {
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    Usuario usuario = parsed.map<Usuario>((json) => Usuario.fromJson(json));

    //cargo los datos del formulario
    _nombreController.text = usuario.nombre;
    _apellidosController.text = usuario.apellidos;
    _correoController.text = usuario.correo;

    /*    setState(() {
      _nombreController.text = usuario.nombre;
      _apellidosController.text = usuario.apellidos;
      _correoController.text = usuario.correo;
    }); */
  } else {
    throw Exception('Failed to load usuario');
  }
}

final _formKey = GlobalKey<FormState>();

TextEditingController _nombreController = TextEditingController();
TextEditingController _apellidosController = TextEditingController();
TextEditingController _correoController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _repeatPasswordController = TextEditingController();

bool _appliedChanges = false;

class _ConfBodyState extends State<_ConfBody> {
  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _apellidosController = TextEditingController();
    _correoController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
    _getUserId();
    _getusuario();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidosController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                  labelText: 'Nombre',
                  filled: true,
                  fillColor: Color.fromARGB(255, 229, 184, 233)),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, introduce tu nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _apellidosController,
              decoration: const InputDecoration(
                  labelText: 'Apellidos',
                  filled: true,
                  fillColor: Color.fromARGB(255, 229, 184, 233)),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, introduce tus apellidos';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _correoController,
              decoration: const InputDecoration(
                  labelText: 'Correo',
                  filled: true,
                  fillColor: Color.fromARGB(255, 229, 184, 233)),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, introduce tu correo';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  filled: true,
                  fillColor: Color.fromARGB(255, 229, 184, 233)),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, introduce una contraseña';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _repeatPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Repetir Contraseña',
                  filled: true,
                  fillColor: Color.fromARGB(255, 229, 184, 233)),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, repite tu contraseña';
                }
                if (value != _passwordController.text) {
                  return 'Las contraseñas no coinciden';
                }
                return null;
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('¿Quieres aplicar los cambios?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _appliedChanges = true;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Aplicar cambios'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Aplicar cambios'),
            ),
            if (_appliedChanges)
              const Text(
                'Cambios aplicados',
                style: TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}
