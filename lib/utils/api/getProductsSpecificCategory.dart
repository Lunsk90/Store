// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchProductsInCategory(String category) async {
  var url = Uri.parse('https://fakestoreapi.com/products/category/$category');
  
  try {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      // Si la solicitud no es exitosa, puedes manejar el error aquí
      print('Request failed with status: ${response.statusCode}.');
      return [];
    }
  } catch (error) {
    // Manejo de errores
    print('Error: $error');
    return [];
  }
}
