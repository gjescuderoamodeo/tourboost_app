import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final IconData? icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  final String formProperty;
  final Map<String, String> formValues;

  const CustomInputField({
    super.key,
    this.hintText,
    this.labelText,
    this.icon,
    this.obscureText = false,
    required this.formProperty,
    required this.formValues, this.keyboardType=TextInputType.text, this.validator,
  });

  // Validador por defecto
  static String? defaultValidator(String? value) {
    if (value == null) return 'Campo requerido';
    //minimo 3 letras
    return value.length < 3 ? 'Mínimo 3 letras' : null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      textCapitalization: TextCapitalization.words,
      //poner el texto con puntitos (contraseña)
      obscureText: obscureText,
      keyboardType: keyboardType,
      //tipo de teclado (movil)
      //keyboardType: TextInputType.emailAddress,
      //almacenar el valor
      onChanged: (value) {
        //le asigno a formValues esa propiedad
        formValues[formProperty] = value;
      },
      //validadores
      validator: validator ?? defaultValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          icon: icon == null ? null : Icon(icon)),
    );
  }
}
