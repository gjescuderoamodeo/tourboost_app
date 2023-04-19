import 'package:flutter/material.dart';
import 'package:tourboost_app/providers/login_form_provider.dart';
import 'package:tourboost_app/services/services.dart';
import 'package:provider/provider.dart';
import 'package:tourboost_app/theme/app_theme.dart';

import 'package:tourboost_app/ui/input_decorations.dart';
import 'package:tourboost_app/widgets/widgets.dart';

import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Provider<AuthService>(
        create: (_) => AuthService(),
        child: AuthBackground(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 250),
                CardContainer(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text('Login',
                          style: Theme.of(context).textTheme.headline4),
                      const SizedBox(height: 30),
                      ChangeNotifierProvider(
                        create: (_) => LoginFormProvider(),
                        child: _LoginForm(),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, 'registro'),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        Colors.indigo.withOpacity(0.1)),
                    shape: MaterialStateProperty.all(StadiumBorder()),
                  ),
                  child: const Text(
                    'Crear una nueva cuenta',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'su_correo@gmail.com',
                  labelText: 'Correo electrónico',
                  prefixIcon: Icons.alternate_email_rounded),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El valor ingresado no luce como un correo';
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '*****',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 3)
                    ? null
                    : 'La contraseña debe de ser de 3 caracteres mínimo';
              },
            ),
            SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: AppTheme.terciary,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(
                      loginForm.isLoading ? 'Espere' : 'Acceder',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        //final authService =
                        //    Provider.of<AuthService>(context, listen: false);
                        final AuthService authService = AuthService();

                        if (!loginForm.isValidForm()) return;

                        loginForm.isLoading = true;

                        // TODO: validar si el login es correcto

                        String? login = await authService.login(
                            loginForm.email, loginForm.password);   

                        if (login != null) {
                          Navigator.pushReplacementNamed(context, 'home');
                        } else {
                          Fluttertoast.showToast(
                              msg: "correo o contraseña no válido",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                              backgroundColor:
                                  const Color.fromARGB(255, 239, 4, 4),
                              textColor: Colors.white,
                              fontSize: 16.0);
                          //NotificationsService.showSnackbar(errorMessage);
                          loginForm.isLoading = false;
                        }
                      })
          ],
        ),
      ),
    );
  }
}
