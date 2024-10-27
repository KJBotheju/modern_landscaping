// ignore_for_file: prefer_final_fields

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  Map<int, Map<String, dynamic>> _cartItems = {};

  CartProvider() {
    _loadCartCounts();
  }

  int getCartCount(int productId) => _cartItems[productId]?['count'] ?? 0;

  String getProductName(int productId) =>
      _cartItems[productId]?['name'] ?? 'Product not found';

  String getProductPrice(int productId) =>
      _cartItems[productId]?['price'] ?? '0';

  void toggleItemInCart(
      int productId, String productName, String productPrice) {
    if (_cartItems.containsKey(productId)) {
      if (_cartItems[productId]!['count'] > 1) {
        _cartItems[productId]!['count']--;
      } else {
        _cartItems.remove(productId);
      }
    } else {
      _cartItems[productId] = {
        'name': productName,
        'price': productPrice,
        'count': 1,
      };
    }
    _saveCartCounts();
    notifyListeners();
  }

  void incrementItem(int productId) {
    if (_cartItems.containsKey(productId)) {
      _cartItems[productId]!['count']++;
    }
    _saveCartCounts();
    notifyListeners();
  }

  void decrementItem(int productId) {
    if (_cartItems.containsKey(productId) &&
        _cartItems[productId]!['count'] > 1) {
      _cartItems[productId]!['count']--;
    }
    _saveCartCounts();
    notifyListeners();
  }

  int get cartCount {
    return _cartItems.values.fold(0, (sum, item) => sum + item['count'] as int);
  }

  int get distinctProductCount => _cartItems.length;

  Map<int, Map<String, dynamic>> get filteredCartItems => _cartItems;

  Future<void> _saveCartCounts() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

    _cartItems.forEach((key, value) {
      prefs.setInt('cart_count_$key', value['count']);
      prefs.setString('cart_name_$key', value['name']);
      prefs.setString('cart_price_$key', value['price']);
    });
  }

  Future<void> _loadCartCounts() async {
    final prefs = await SharedPreferences.getInstance();
    _cartItems.clear();

    for (int i = 0; i < 100; i++) {
      final count = prefs.getInt('cart_count_$i');
      if (count != null && count > 0) {
        final name = prefs.getString('cart_name_$i');
        final price = prefs.getString('cart_price_$i');
        _cartItems[i] = {
          'count': count,
          'name': name,
          'price': price,
        };
      }
    }
    notifyListeners();
  }

  Future<void> clearCartData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _cartItems.clear();
    notifyListeners();
  }
}
