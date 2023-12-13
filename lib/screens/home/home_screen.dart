// ignore_for_file: use_build_context_synchronously, avoid_print
import 'package:flutter/material.dart';
import 'package:fl_components/screens/login/login.dart';
import 'package:fl_components/theme/app_theme.dart';
import 'package:fl_components/router/app_routes.dart';
import '../screens.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final String? email; // Cambio aquí: email es ahora un parámetro opcional
  const HomeScreen({Key? key, this.email}) : super(key: key); // Modificación aquí

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuOptions = AppRoutes.menuOptions;

    return Scaffold(
      appBar: AppBar(
        title: Text(email ?? ''), // Usar email ?? '' para manejar el caso donde email es null
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () async {
              final updatedImage = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(
                    avatarImage: const AssetImage('assets/defaul_avatar.png'),
                    email: email ?? '', // Usar email ?? '' para manejar el caso donde email es null
                  ),
                ),
              );

              if (updatedImage != null) {
                // Actualizar imagen en HomeScreen
                // ...
                // Agregar la lógica para actualizar la imagen en HomeScreen
                // setState(() {
                //   avatarImage = updatedImage;
                // });
              }
            },
            child: const CircleAvatar(
              backgroundImage: AssetImage('assets/defaul_avatar.png'),
            ),
          ),
        ),
        actions: [
          Tooltip(
            message: 'Historial de Compras', // Mensaje que se mostrará al pasar el cursor
            child: Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PurchaseHistoryDatabaseScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, i) => ListTile(
                leading: Icon(
                  menuOptions[i].icon,
                  color: AppTheme.primary,
                ),
                title: Text(menuOptions[i].name),
                onTap: () {
                  Navigator.pushNamed(context, menuOptions[i].route);
                },
              ),
              separatorBuilder: (_, __) => const Divider(),
              itemCount: menuOptions.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 65, right: 65, bottom: 30),
            child: ElevatedButton.icon(
              onPressed: () => signOut(context),
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
            ),
          ),
        ],
      ),
    );
  }
}
