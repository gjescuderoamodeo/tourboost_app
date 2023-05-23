import 'package:flutter/material.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class AppRoutes {
  //static const initialRoute = 'login';
  static const initialRoute = 'home2';

  //para tenerlo más bonito
  static final menuOptions = <MenuOption>[
    MenuOption(
        route: 'home',
        name: 'Home Screen',
        screen: HomeScreen(),
        icon: Icons.home),
    MenuOption(
        route: 'home2',
        name: 'Home Screen2',
        screen: HomeScreen2(),
        icon: Icons.home),
    MenuOption(
        route: 'map',
        name: 'map Screen',
        screen: MapScreen(),
        icon: Icons.home),
    MenuOption(
        route: 'login',
        name: 'login Screen',
        screen: LoginScreen(),
        icon: Icons.login),
    MenuOption(
        route: 'registro',
        name: 'registro users Screen',
        screen: RegistroScreen(),
        icon: Icons.receipt),
    MenuOption(
        route: 'configuracion',
        name: 'configuracion Screen',
        screen: ConfiguracionScreen(),
        icon: Icons.room_preferences),
    MenuOption(
        route: 'adminhotel',
        name: 'admin hotel Screen',
        screen: AdminHotelScreen(),
        icon: Icons.roofing),
    MenuOption(
        route: 'adminpais',
        name: 'admin pais Screen',
        screen: AdminPaisScreen(),
        icon: Icons.roofing),
    MenuOption(
        route: 'marcadores',
        name: 'marcadores Screen',
        screen: MarcadoresScreen(),
        icon: Icons.star),
    MenuOption(
        route: 'reservas',
        name: 'reservas Screen',
        screen: ReservasScreen(),
        icon: Icons.hotel),
    MenuOption(
        route: 'adminmarcadores',
        name: 'admin marcadores Screen',
        screen: AdminMarcadoresScreen(),
        icon: Icons.star),
    MenuOption(
        route: 'hoteles',
        name: 'hoteles Screen',
        screen: HotelesScreen(),
        icon: Icons.holiday_village),
    MenuOption(
        route: 'hotel',
        name: 'hotel Screen',
        screen: HotelScreen(),
        icon: Icons.holiday_village_rounded),
    MenuOption(
        route: 'recomendacion',
        name: 'recomendacion Screen',
        screen: RecomendacionScreen(),
        icon: Icons.read_more),
    MenuOption(
        route: 'paises',
        name: 'paises Screen',
        screen: PaisesScreen(),
        icon: Icons.countertops),
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    for (final option in menuOptions) {
      appRoutes.addAll({option.route: (BuildContext context) => option.screen});
    }

    return appRoutes;
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const AlertScreen());
  }
}
