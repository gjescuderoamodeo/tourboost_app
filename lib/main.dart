import 'package:flutter/material.dart';
import 'package:tourboost_app/theme/app_theme.dart';
import 'router/app_routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TourBoost',
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.getAppRoutes(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
      //tema global
      theme: AppTheme.lightTheme,
      
    );
  }
}
