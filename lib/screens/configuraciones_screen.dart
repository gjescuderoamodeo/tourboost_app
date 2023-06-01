import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class ConfiguracionesScreen extends StatelessWidget {
  const ConfiguracionesScreen({super.key});

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

class _ConfBodyState extends State<_ConfBody> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();

  final TextEditingController _apellidosController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _repeatPasswordController =
      TextEditingController();

  bool _appliedChanges = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidosController.dispose();
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
