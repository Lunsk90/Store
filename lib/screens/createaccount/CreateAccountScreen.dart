// ignore_for_file: library_private_types_in_public_api, file_names, use_build_context_synchronously

import 'package:fl_components/screens/screens.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../utils/states/signUpUser.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  String email = '';
  String password = '';
  final authenticationHelper = AuthenticationHelper();
  //final _storage = const FlutterSecureStorage();

  void _signUpUser() async {
    if (email.isNotEmpty && password.isNotEmpty) {
      // Lógica de registro de usuario
      bool signUpSuccess =
          await authenticationHelper.signUpUser(email, password);
      if (signUpSuccess) {
        // Registro exitoso, maneja la navegación o la lógica deseada aquí

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Maneja el caso de error en el registro
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hubo un error en el registro')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cuenta'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightBlue.withOpacity(0.7),
              Colors.blue,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Correo Electrónico'),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _signUpUser();
                },
                child: const Text(
                  'Crear Cuenta',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
