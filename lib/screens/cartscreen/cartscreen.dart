// ignore_for_file: library_private_types_in_public_api
import 'package:fl_components/models/CartProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final String? email;

  const CartScreen({Key? key, required this.cartItems, this.email}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void removeFromCart(int index) {
    CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.removeFromCart(index);
  }

  void clearCart() {
    CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.clearCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text('No tienes nada en el carrito'))
          : ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.network(
                      item['image'] ?? '',
                      width: 50,
                      height: 50,
                      fit: BoxFit.scaleDown,
                    ),
                    title: Text(item['title'] ?? ''),
                    subtitle: Text('\$${item['price'] ?? ''}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        removeFromCart(index);
                      },
                    ),
                  ),
                );
              },
            ),

      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PurchaseHistoryScreen(purchaseHistory: widget.cartItems),
                ),
              );
            },
            child: const Text('Completar compra'),
          ),
        ),
      ),
    );
  }
}
