import 'package:flutter/material.dart';
import 'package:tourboost_app/services/auth_service.dart';
import 'package:tourboost_app/theme/app_theme.dart';
import 'package:tourboost_app/widgets/widgets.dart';

class ConfiguracionesScreen extends StatelessWidget {
  const ConfiguracionesScreen({Key? key}) : super(key: key);

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

          Navigator.pushNamed(context, 'configuracion', arguments: userId);
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
          child: Text('Borrar cuenta',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        ),
        onTap: () {
          // Acción cuando se toque la tarjeta "Borrar cuenta"
        },
      ),
    );
  }
}