// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:fl_components/widget/widget.dart';
import 'package:fl_components/utils/api/getProductsSpecificCategory.dart';

import '../screens.dart';

class CardScreen extends StatefulWidget {
  final String categoryName;

  const CardScreen({Key? key, required this.categoryName}) : super(key: key);

  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  List<Map<String, dynamic>> cartItems = []; // Lista para mantener elementos seleccionados

  @override
  Widget build(BuildContext context) {
    print('Category Name: ${widget.categoryName}');

    Future<List<Map<String, dynamic>>> obtenerProductosEnElectronica() async {
      List<dynamic> productos = await fetchProductsInCategory(widget.categoryName);
      return productos.cast<Map<String, dynamic>>();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Electronics'),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(cartItems: cartItems),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart), // Icono del carrito de compras
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 11,
                  top: 1,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 10,
                    child: Text(
                      '${cartItems.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: obtenerProductosEnElectronica(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];
                return CustomCardType2(
                  imageUrl: product['image'],
                  name: product['title'],
                  price: product['price'].toString(),
                  description: product['description'],
                  onAddToCartPressed: () {
                    setState(() {
                      cartItems.add(product);
                      print('🥸🥸 Cart items: $cartItems');
                    });
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
