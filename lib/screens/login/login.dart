// ignore_for_file: unused_local_variable, use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_components/models/AuthUtils.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fl_components/screens/home/home_screen.dart';
import 'package:fl_components/widget/custom_input_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();

    Map<String, String> formValue = {
      'email': '',
      'password': '',
    };

    Future<void> signInWithEmailAndPassword(BuildContext context) async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: formValue['email'] ?? '',
          password: formValue['password'] ?? '',
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(email: AuthUtils.getEmail(userCredential.user)),
          ),
        );
      } catch (e) {
        print('Error de inicio de sesión: $e');
        String errorMessage = 'Ocurrió un error al iniciar sesión. Por favor, inténtalo de nuevo o contacta al encargado de la aplicación. O puede iniciar sesión con su cuenta de Google';
        if (e is FirebaseAuthException) {
          if (e.code == 'user-not-found' || e.code == 'wrong-password') {
            errorMessage = 'Por favor, comunícate con el encargado de la aplicación, ya que no posees una cuenta válida en esta app.';
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

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        final bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

        if (isNewUser) {
          // Realizar alguna acción si es un usuario nuevo
        }

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(email: AuthUtils.getEmail(userCredential.user)),
          ),
        );
      } catch (e) {
        print('Error de inicio de sesión con Google: $e');
      }
    }

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://iphoneswallpapers.com/wp-content/uploads/2023/07/Retro-Streets-iPhone-Wallpaper-4K.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: myFormKey,
                child: Column(
                  children: [
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
                    ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (!myFormKey.currentState!.validate()) {
                          print('Formulario no válido');
                          return;
                        }
                        signInWithEmailAndPassword(context);
                      },
                      child: const SizedBox(
                        width: double.infinity,
                        child: Center(child: Text('Login')),
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      onPressed: () {
                        signInWithGoogle(context);
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Iniciar sesión con Google'),
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
