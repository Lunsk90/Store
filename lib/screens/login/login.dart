// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_components/models/AuthUtils.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fl_components/widget/custom_input_field.dart';

import '../screens.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();
  bool _sliderEnabled = false; // Estado del checkbox

  Map<String, String> formValue = {
    'email': '',
    'password': '',
  };

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: formValue['email'] ?? '',
        password: formValue['password'] ?? '',
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              HomeScreen(email: AuthUtils.getEmail(userCredential.user)),
        ),
      );
    } catch (e) {
      print('Error de inicio de sesión: $e');
      String errorMessage =
          'Ocurrió un error al iniciar sesión. Por favor, inténtalo de nuevo o contacta al encargado de la aplicación. O puede iniciar sesión con su cuenta de Google';
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          errorMessage =
              'Por favor, comunícate con el encargado de la aplicación, ya que no posees una cuenta válida en esta app.';
        }
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error de inicio de sesión'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final bool isNewUser =
          userCredential.additionalUserInfo?.isNewUser ?? false;

      if (isNewUser) {
        // Realizar alguna acción si es un usuario nuevo
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              HomeScreen(email: AuthUtils.getEmail(userCredential.user)),
        ),
      );
    } catch (e) {
      print('Error de inicio de sesión con Google: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: myFormKey,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/MANUAL_BCR OK-11.png', // Reemplaza con la ruta de tu imagen
                      height: 100,
                      width: 100,
                      // Ajusta el tamaño de la imagen según tus preferencias
                    ),
                    const SizedBox(height: 30),
                    CustomInputField(
                      labelText: 'Email',
                      hintText: 'Email',
                      helperText: 'Email',
                      formProperty: 'email',
                      fromValues: formValue,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    CustomInputField(
                      labelText: 'Password',
                      hintText: 'Password',
                      helperText: 'Password',
                      formProperty: 'password',
                      fromValues: formValue,
                      isPassword: true,
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile.adaptive(
                      value: _sliderEnabled,
                      onChanged: (value) {
                        setState(() {
                          _sliderEnabled = value ?? false;
                        });
                      },
                      title: const Text('Recordar mi usuario'),
                      activeColor: Colors.blue,
                      checkColor: Colors.white,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 13, 110, 253), // Cambia este color al deseado
                      ),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (!myFormKey.currentState!.validate()) {
                          print('Formulario no válido');
                          return;
                        }
                        signInWithEmailAndPassword(context);
                      },
                      child: const SizedBox(
                        width: 240,
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SwitchListTile.adaptive(
                      value: _sliderEnabled,
                      onChanged: (value) {
                        setState(() {
                          _sliderEnabled = value;
                        });
                      },
                      title: const Text('Ingresar con Face ID'),
                      activeColor: Colors.blue,
                      inactiveTrackColor: Colors.white,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Olvide mi contraseña',
                      style:
                          TextStyle(color: Color.fromARGB(255, 13, 110, 253)),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 13, 110,
                              253), // Cambia este color al deseado
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TabBarTopScreen(),
                            ),
                          );
                        },
                        child: const SizedBox(
                          width: 90,
                          child: Center(
                            child: Text(
                              'Registrase',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
