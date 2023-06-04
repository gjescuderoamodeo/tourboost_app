import 'package:flutter/material.dart';
import 'package:tourboost_app/services/auth_service.dart';
import 'package:tourboost_app/theme/app_theme.dart';
import 'package:tourboost_app/widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

late int _idUser;
//función obtener id usuario
Future<void> _getUserId() async {
  final AuthService authService = AuthService();

  //obtener token
  final token = await authService.readToken();
  final userId = authService.getUserIdFromToken(token);

  _idUser = userId;
}

//borrar usuario api
Future<void> _delUsuario(context) async {
  final body = {
    'idUsuario': _idUser,
  };

  final response = await http.delete(
    Uri.parse('https://tour-boost-api.vercel.app/usuario'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(body),
  );

  print(response.statusCode);

  if (response.statusCode == 200) {
    Navigator.popAndPushNamed(context, 'login');
  } else {
    throw Exception('Failed to delete usuario');
  }
}

class ConfiguracionesScreen extends StatefulWidget {
  const ConfiguracionesScreen({Key? key}) : super(key: key);

  @override
  State<ConfiguracionesScreen> createState() => _ConfiguracionesScreenState();
}

class _ConfiguracionesScreenState extends State<ConfiguracionesScreen> {
  @override
  void initState() {
    super.initState();
    _getUserId();
  }

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
          _ConfBody(),
        ],
      ),
    );
  }
}

class _ConfBody extends StatefulWidget {
  @override
  State<_ConfBody> createState() => _ConfBodyState();
}

class _ConfBodyState extends State<_ConfBody> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          ConfigurarUsuarioCard(),
          const SizedBox(
            height: 10,
          ),
          BorrarCuentaCard(),
        ],
      ),
    );
  }
}

class ConfigurarUsuarioCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: AppTheme.secundary,
      elevation: 10,
      child: ListTile(
        title: const Center(
          child: Text(
            'Configurar usuario',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: () async {
          //ir a configuracion screen
          final AuthService authService = AuthService();

          //obtener token
          final token = await authService.readToken();
          final userId = authService.getUserIdFromToken(token);

          Navigator.pushNamed(context, 'configuracion');
        },
      ),
    );
  }
}

class BorrarCuentaCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: AppTheme.secundary,
      color: AppTheme.alert,
      elevation: 10,
      child: ListTile(
        title: const Center(
          child: Text('Cancelar cuenta',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('¿Desea borrar su cuenta?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppTheme.alert),
                  ),
                  onPressed: () {
                    _delUsuario(context);
                  },
                  child: const Text('Borrar cuenta'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
