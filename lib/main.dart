import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_components/models/CartProvider.dart';
import 'package:fl_components/theme/app_theme.dart';
import 'package:fl_components/router/app_routes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase con las opciones adecuadas para la plataforma actual
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCcKeYgDqOi85l-1lNc9WkPhg47nIVBmjw',
      appId: '1:599784223139:android:2915fed261de4b72562a16',
      messagingSenderId: '599784223139',
      projectId: 'products-65828',
      storageBucket: 'gs://products-65828.appspot.com',
      databaseURL: 'https://products-65828-default-rtdb.firebaseio.com/',
    ),
  );

  // Crea una instancia del proveedor del carrito
  CartProvider cartProvider = CartProvider();

  // Carga el historial de compras desde Firebase
  await cartProvider.fetchPurchaseHistoryFromFirebase();

  // Inicia la aplicación Flutter
  runApp(
    ChangeNotifierProvider.value(
      value: cartProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.getAppRoutes(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
      theme: AppTheme.lightTheme,
    );
  }
}
