// ignore_for_file: prefer_final_fields

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  Map<int, int> _cartCounts = {};

  CartProvider() {
    _loadCartCounts();
  }

  int getCartCount(int index) => _cartCounts[index] ?? 0;

  void toggleItemInCart(int index) {
    if (_cartCounts.containsKey(index)) {
      if (_cartCounts[index]! > 0) {
        _cartCounts[index] = _cartCounts[index]! - 1;
      } else {
        _cartCounts[index] = 1;
      }
    } else {
      _cartCounts[index] = 1;
    }
    _saveCartCounts();
    notifyListeners();
  }

  int get cartCount {
    return _cartCounts.values.fold(0, (sum, count) => sum + count);
  }

  Future<void> _saveCartCounts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _cartCounts.forEach((key, value) {
      prefs.setInt('cart_count_$key', value);
    });
  }

  Future<void> _loadCartCounts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 100; i++) {
      final int? count = prefs.getInt('cart_count_$i');
      if (count != null) {
        _cartCounts[i] = count;
      }
    }
    notifyListeners();
  }
}
