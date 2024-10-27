// ignore_for_file: prefer_final_fields

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  Map<int, Map<String, dynamic>> _cartItems = {};

  CartProvider() {
    _loadCartCounts();
  }

  int getCartCount(int index) => _cartItems[index]?['count'] ?? 0;

  String getProductName(int index) =>
      _cartItems[index]?['name'] ?? 'Unknown Product';

  String getProductPrice(int index) => _cartItems[index]?['price'] ?? '0';

  void toggleItemInCart(int index, String productName, String productPrice) {
    if (_cartItems.containsKey(index)) {
      if (_cartItems[index]!['count'] > 0) {
        _cartItems[index]!['count']--;
      } else {
        _cartItems[index]!['count'] = 1;
      }
    } else {
      _cartItems[index] = {
        'name': productName,
        'price': productPrice,
        'count': 1,
      };
    }
    _saveCartCounts();
    notifyListeners();
  }

  int get cartCount {
    return _cartItems.values.fold(0, (sum, item) => sum + item['count'] as int);
  }

  int get distinctProductCount => _cartItems.length;

  Future<void> _saveCartCounts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _cartItems.forEach((key, value) {
      prefs.setInt('cart_count_$key', value['count']);
      prefs.setString('cart_name_$key', value['name']);
      prefs.setString('cart_price_$key', value['price']);
    });
  }

  Future<void> _loadCartCounts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 100; i++) {
      final int? count = prefs.getInt('cart_count_$i');
      if (count != null) {
        String? name = prefs.getString('cart_name_$i');
        String? price = prefs.getString('cart_price_$i');
        _cartItems[i] = {
          'count': count,
          'name': name,
          'price': price,
        };
      }
    }
    notifyListeners();
  }
}
