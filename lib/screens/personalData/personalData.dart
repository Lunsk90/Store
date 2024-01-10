// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../widget/widget.dart';
import '../screens.dart';

class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({Key? key}) : super(key: key);

  @override
  _PersonalDataScreenState createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  final _storage = const FlutterSecureStorage();
  Map<String, String> formValue = {
    'name': '',
    'lastName': '',
  };
  String name = '';
  String lastName = '';

  @override
  void initState() {
    super.initState();
    _loadData(); // Cargar datos al iniciar la pantalla
  }

  Future<void> _loadData() async {
    name = await _storage.read(key: 'name') ?? '';
    lastName = await _storage.read(key: 'lastName') ?? '';
    setState(() {}); // Actualizar la interfaz con los datos cargados
  }

  Future<void> _saveData() async {
    if (name.isNotEmpty && lastName.isNotEmpty) {
      await _storage.write(key: 'name', value: name);
      await _storage.write(key: 'lastName', value: lastName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomInputField(
                labelText: 'Email',
                hintText: 'Email',
                helperText: 'Email',
                formProperty: 'email',
                fromValues: formValue,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 40),
              CustomInputField(
                labelText: 'Password',
                hintText: 'Password',
                helperText: 'Password',
                formProperty: 'password',
                fromValues: formValue,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 13, 110, 253), // Cambia este color al deseado
                ),
                onPressed: () async {
                  await _saveData();
                  if (name.isNotEmpty && lastName.isNotEmpty) {
                    print('Nombre: $name, Apellido: $lastName');
                    // Realizar alguna acción con los datos, como guardarlos en Firebase
                  }
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const FaceDetectionScreen(),
                  ));
                },
                child: const Text(
                  'Guardar Datos',
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
