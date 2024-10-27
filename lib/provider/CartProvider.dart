import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  Map<int, int> _cartCounts = {}; // Map to track counts for each product

  int getCartCount(int index) =>
      _cartCounts[index] ?? 0; // Get count for a specific product

  void toggleItemInCart(int index) {
    if (_cartCounts.containsKey(index)) {
      if (_cartCounts[index]! > 0) {
        _cartCounts[index] = _cartCounts[index]! - 1; // Decrement count
      } else {
        _cartCounts[index] = 1; // Increment count to 1
      }
    } else {
      _cartCounts[index] = 1; // First time adding this item
    }
    notifyListeners();
  }

  int get cartCount {
    return _cartCounts.values
        .fold(0, (sum, count) => sum + count); // Total cart count
  }
}
