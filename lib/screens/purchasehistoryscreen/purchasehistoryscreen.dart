// ignore_for_file: unused_element, avoid_print, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_components/models/AuthUtils.dart';
import 'package:fl_components/models/CartProvider.dart';
import 'package:provider/provider.dart';

class PurchaseHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> purchaseHistory;

  const PurchaseHistoryScreen({Key? key, required this.purchaseHistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String userEmail = AuthUtils.getEmail(currentUser);

    CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);

    Future<void> saveToFirebase() async {
      for (var item in purchaseHistory) {
        await cartProvider.addToPurchaseHistory(item);
      }
    }

    // Llamada para guardar los datos en Firebase
    saveToFirebase();

    print('Email del usuario: $userEmail');
    print('Detalles del purchaseHistory: ${purchaseHistory.toString()}');

    void accessPurchaseHistory() {
      List<Map<String, dynamic>> purchaseHistory = cartProvider.purchaseHistory;

      // Acceso a la data en purchaseHistory
      purchaseHistory.forEach((item) {
        print('Email del item: $item'); // Imprimirá cada elemento del historial de compras
      });
    }

    // Resto de tu código de UI...

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase History'),
      ),
      body: ListView.builder(
        itemCount: purchaseHistory.length,
        itemBuilder: (context, index) {
          final item = purchaseHistory[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              child: ListTile(
                leading: Image.network(
                  item['image'] ?? '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.scaleDown,
                ),
                title: Text(item['title'] ?? ''),
                subtitle: Text('\$${item['price'] ?? ''}'),
                onTap: () {
                  _showPurchaseDetails(context, item);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPurchaseDetails(BuildContext context, Map<String, dynamic> purchaseDetails) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalle de la compra'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Producto: ${purchaseDetails['title'] ?? ''}'),
              Text('Precio: \$${purchaseDetails['price'] ?? ''}'),
              Text('Descripción: ${purchaseDetails['description'] ?? ''}'),
              // Agregar más detalles si es necesario
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
