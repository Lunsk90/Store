// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:fl_components/widget/widget.dart';

class InsputsScreen extends StatelessWidget {
  const InsputsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();

    final Map<String, String> formValue = {
      'firt_name': 'Alcide',
      'last_name': 'Ramírez',
      'email': 'alcides.lunsk@gmail.com',
      'password': '123456',
      'role': 'Admin',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inputs'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: myFormKey,
            child: Column(
              children: [
                CustomInputField(
                  labelText: 'Nombre',
                  hintText: 'Nombre del usuario',
                  helperText: 'Nombre del usuario',
                  formProperty: 'firt_name',
                  fromValues: formValue,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomInputField(
                  labelText: 'Apellido',
                  hintText: 'Apellido del usuario',
                  helperText: 'Apellido del usuario',
                  formProperty: 'last_name',
                  fromValues: formValue,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomInputField(
                  labelText: 'Email',
                  hintText: 'Email',
                  helperText: 'Email',
                  formProperty: 'email',
                  fromValues: formValue,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomInputField(
                  labelText: 'Password',
                  hintText: 'Password',
                  helperText: 'Password',
                  formProperty: 'password',
                  fromValues: formValue,
                  isPassword: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                DropdownButtonFormField(
                  items: const [
                    DropdownMenuItem(
                      value: 'Admin',
                      child: Text('Admin'),
                    ),
                    DropdownMenuItem(
                      value: 'Empleado',
                      child: Text('Empleado'),
                    ),
                    DropdownMenuItem(
                      value: 'Cliente',
                      child: Text('Cliente'),
                    ),
                    DropdownMenuItem(
                      value: 'User',
                      child: Text('User'),
                    ),
                  ],
                  onChanged: (value) {
                    print(value);
                    formValue['role'] = value ?? 'Admin';
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (!myFormKey.currentState!.validate()) {
                        print('Fromulario no valido');
                        return;
                      }

                      print(formValue);
                    },
                    child: const SizedBox(
                        width: double.infinity,
                        child: Center(child: Text('Guardar'))))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
