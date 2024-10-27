// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:modern_landscaping/checkout/CheckoutPage.dart';
import 'package:provider/provider.dart';
import 'package:modern_landscaping/provider/CartProvider.dart';

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward, color: Colors.black),
            onPressed: () {
              // Navigate to checkout page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CheckoutPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: cartProvider.distinctProductCount > 0
          ? ListView.builder(
              itemCount: cartProvider.distinctProductCount,
              itemBuilder: (context, index) {
                final productName = cartProvider.getProductName(index);
                final productPrice = cartProvider.getProductPrice(index);
                final productCount = cartProvider.getCartCount(index);

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(productName),
                    subtitle:
                        Text('Price: $productPrice\nQuantity: $productCount'),
                    trailing: Text(
                      'Total: Rs ${double.parse(productPrice.replaceAll('Rs ', '')) * productCount}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text('Your cart is empty!'),
            ),
    );
  }
}
