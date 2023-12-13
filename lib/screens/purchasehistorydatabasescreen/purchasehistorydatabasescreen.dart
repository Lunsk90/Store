import 'package:fl_components/models/CartProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PurchaseHistoryDatabaseScreen extends StatelessWidget {
  const PurchaseHistoryDatabaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Compras'),
      ),
      body: FutureBuilder(
        future: cartProvider.fetchPurchaseHistoryFromFirebase(), // Obtener datos del historial desde Firebase
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar datos'));
          } else {
            List<Map<String, dynamic>> purchaseHistory = cartProvider.purchaseHistory;

            return ListView.builder(
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
            );
          }
        },
      ),
    );
  }

  void _showPurchaseDetails(BuildContext context, Map<String, dynamic> purchaseDetails) {
    // Lógica para mostrar los detalles de la compra en un AlertDialog
  }
}
