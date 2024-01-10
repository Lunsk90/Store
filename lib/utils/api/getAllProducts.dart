// ignore_for_file: avoid_print, file_names

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<String>> fetchAllCategories() async {
  var url = Uri.parse('https://fakestoreapi.com/products/categories');
  try {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<String> categories = jsonResponse.cast<String>(); // Convertir los objetos a Strings
      return categories;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return []; // Devolver una lista vacía en caso de error
    }
  } catch (error) {
    print('Error: $error');
    return []; // Devolver una lista vacía en caso de error
  }
}
