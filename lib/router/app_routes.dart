// ignore_for_file: avoid_print

import 'package:fl_components/models/menu_options.dart';
import 'package:fl_components/screens/login/login.dart';
import 'package:fl_components/screens/screens.dart';
import 'package:fl_components/utils/api/getAllProducts.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const initialRoute = 'home';
  static List<MenuOption> menuOptions = [
    MenuOption(
      route: 'card',
      name: 'categoria1',
      screen: const CardScreen(categoryName: 'electronics',),
      icon: Icons.electric_meter_outlined,
    ),
    MenuOption(
      route: 'card2',
      name: 'categoria2',
      screen: const NeighborhoodScreen(categoryName: 'jewelery',),
      icon: Icons.diamond_outlined,
    ),
    MenuOption(
      route: 'avatar',
      name: 'categoria3',
      screen: const AvatarScreen(categoryName: "men's clothing",),
      icon: Icons.checkroom_outlined,
    ),
    MenuOption(
      route: 'animated',
      name: 'categoria4',
      screen: const AnimatedScreen(categoryName: "women's clothing",),
      icon: Icons.checkroom_outlined,
    ),
  ];

  static Future<void> updateMenuOptionsWithCategories() async {
    List<String> categories = await fetchAllCategories();
    print('Categorías obtenidas: $categories');

    if (categories.length == menuOptions.length) {
      for (int i = 0; i < categories.length; i++) {
        menuOptions[i].name = categories[i];
      }
      print('MenuOptions actualizado: $menuOptions');
    } else {
      print('La cantidad de categorías obtenidas no coincide con las opciones de menú existentes.');
      // Manejar la situación cuando la cantidad no coincide
    }
  }

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    // Actualizar las categorías antes de generar las rutas
    updateMenuOptionsWithCategories();

    Map<String, Widget Function(BuildContext)> appRoutes = {};
    appRoutes.addAll({
      'home': (BuildContext context) => const LoginScreen(),
    });
    for (final options in menuOptions) {
      appRoutes.addAll({
        options.route: (BuildContext context) => options.screen,
      });
    }
    return appRoutes;
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const AlertScreen());
  }
}