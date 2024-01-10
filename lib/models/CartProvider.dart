// ignore_for_file: deprecated_member_use, prefer_final_fields, file_names, avoid_print, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CartProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];
  List<Map<String, dynamic>> _purchaseHistory = []; // Historial de compras
  final DatabaseReference _database = FirebaseDatabase.instance.reference(); // Referencia a la base de datos

  List<Map<String, dynamic>> get cartItems => _cartItems;
  List<Map<String, dynamic>> get purchaseHistory => _purchaseHistory;

  void addToCart(Map<String, dynamic> newItem) {
    _cartItems.add(newItem);
    notifyListeners();
  }

  void removeFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  Future<void> addToPurchaseHistory(Map<String, dynamic> newItem) async {
    try {
      await _database.child('purchaseHistory').push().set(newItem); // Agregar un nuevo elemento al historial de compras en Firebase
      _purchaseHistory.add(newItem); // Agregar elemento al historial de compras local
      notifyListeners();
    } catch (error) {
      print('Error al agregar al historial de compras: $error');
    }
  }

  Future<void> fetchPurchaseHistoryFromFirebase() async {
    try {
      var snapshot = await _database.child('purchaseHistory').once();
      if (snapshot != null && snapshot.snapshot != null) {
        // Accede al DataSnapshot desde el evento
        DataSnapshot dataSnapshot = snapshot.snapshot;

        // Convierte los datos a la estructura deseada
        if (dataSnapshot.value != null) {
          Map<dynamic, dynamic> values = dataSnapshot.value as Map<dynamic, dynamic>;
          List<Map<String, dynamic>> purchaseHistoryList = [];
          values.forEach((key, value) {
            purchaseHistoryList.add(Map<String, dynamic>.from(value));
          });
          _purchaseHistory = purchaseHistoryList;
        }
      }
      notifyListeners();
    } catch (error) {
      print('Error al obtener el historial de compras desde Firebase: $error');
    }
  }

}
