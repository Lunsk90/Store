// ignore_for_file: avoid_print, file_names

import 'package:http/http.dart' as http;
import 'dart:convert';

List<dynamic> products = []; // Variable para almacenar los productos obtenidos de la API

Future<List<dynamic>> fetchAllCategories() async {
  var url = Uri.parse('https://fakestoreapi.com/products/categories');
  try {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      products = jsonResponse; // Almacenar los productos en la variable
      return products;
    } else {
      // Manejar el caso de respuesta no exitosa
      print('Request failed with status: ${response.statusCode}.');
      return [];
    }
  } catch (error) {
    // Manejo de errores
    print('Error: $error');
    return [];
  }
}

List<dynamic> getProducts() {
  return products; // Función para obtener los productos
}
