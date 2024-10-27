// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modern_landscaping/provider/CartProvider.dart';
import 'package:modern_landscaping/checkout/CheckoutPage.dart';

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Cart'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            onPressed: () {
              cartProvider.clearCartData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Cart cleared successfully!',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Expanded(
            child: cartProvider.distinctProductCount > 0
                ? ListView.builder(
                    itemCount: cartProvider.distinctProductCount,
                    itemBuilder: (context, index) {
                      final productId =
                          cartProvider.filteredCartItems.keys.elementAt(index);
                      final productName =
                          cartProvider.getProductName(productId);
                      final productPrice =
                          cartProvider.getProductPrice(productId);
                      final productCount = cartProvider.getCartCount(productId);

                      return ListTile(
                        title: Text(productName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Price: $productPrice'),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    cartProvider.decrementItem(productId);
                                  },
                                ),
                                Text('$productCount'),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    cartProvider.incrementItem(productId);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Text(
                          'Total: Rs ${double.parse(productPrice.replaceAll('Rs ', '')) * productCount}',
                        ),
                      );
                    },
                  )
                : Center(child: Text('Your cart is empty!')),
          ),
          if (cartProvider.distinctProductCount > 0)
            Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(),
                    ),
                  );
                },
                child: Text(
                  'Checkout',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.green,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
