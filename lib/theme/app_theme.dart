import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  //color primario
  static const Color primary = Colors.indigo;
  static const Color secundary = Color.fromARGB(255, 73, 32, 233);
  static const Color terciary = Color.fromARGB(255, 63, 8, 165);
  TextTheme Logo = GoogleFonts.lobsterTextTheme().copyWith(
    bodyText1: TextStyle(
      color: Colors.white,
      fontSize: 50,
    ),
    bodyText2: TextStyle(
      color: Colors.white,
      fontSize: 50,
    ),
  );
  static TextStyle logoStyle =
      GoogleFonts.lobsterTextTheme().bodyText1!.copyWith(
            fontSize: 50,
            color: Colors.white,
          );
  static final ThemeData lightTheme = ThemeData.light().copyWith(
      primaryColor: Colors.indigo,
      appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 73, 32, 233), elevation: 0),
      //color botones
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            primary: Colors.indigo, shape: const StadiumBorder()),
      ),
      inputDecorationTheme: const InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: primary),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primary),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20))),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
          ),
          border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(20)))));
}
