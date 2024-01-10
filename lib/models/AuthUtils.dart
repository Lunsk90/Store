// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';

class AuthUtils {
  static String getEmail(User? user) {
    return user?.email ?? '';
  }
}
