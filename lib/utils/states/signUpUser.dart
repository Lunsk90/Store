// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable, avoid_print

import 'package:amazon_cognito_identity_dart_2/cognito.dart'
    show AttributeArg, CognitoUserPool;

class AuthenticationHelper {
  var POOL_ID_DEV = 'us-east-1_FMnbSzNNa';
  var CLIENT_ID_DEV = '16867oefojr499vaupbtrbh9lp';
  var REGION_DEV = 'us-east-1';
  Future<bool> signUpUser(String email, String password) async {
    // Lógica de registro de usuario similar a _signUpUser en LoginBloc
    try {
      String poolID = POOL_ID_DEV;
      String clientID = CLIENT_ID_DEV;
      final userPool = CognitoUserPool(poolID, clientID);

      final userAttributes = [
        AttributeArg(name: 'email', value: email),
      ];

      var data = await userPool.signUp(email, password,
          userAttributes: userAttributes);
      return true; // Registro exitoso
    } catch (e) {
      print(e);
      return false; // Manejar el caso de error
    }
  }

  Future<bool> verifyEmailDomain(String email) async {
    // Lógica de verificación de dominio de correo similar a _verifyEmailDomain en LoginBloc
    final bool emailValid =
        RegExp(r"^[a-zA-Z0-9.a-z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-z0-9]+\.[a-z]+")
            .hasMatch(email);

    if (validateUserStructure(email)) {
      if (emailValid) {
        return RegExp(r'^[a-z0-9_.+-]+@bcr.gob.sv$').hasMatch(email);
      } else {
        return false;
      }
    } else {
      return emailValid
          ? RegExp(r'^[a-z0-9_.+-]+@bcr.gob.sv$').hasMatch(email)
          : false;
    }
  }

  bool validateUserStructure(String value) {
    String pattern = r"^[a-z0-9._-]+$";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
