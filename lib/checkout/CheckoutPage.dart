// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modern_landscaping/provider/CartProvider.dart';

class CheckoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: cartProvider.distinctProductCount > 0
          ? ListView.builder(
              itemCount: cartProvider.distinctProductCount,
              itemBuilder: (context, index) {
                final productId =
                    cartProvider.filteredCartItems.keys.elementAt(index);
                final productName = cartProvider.getProductName(productId);
                final productPrice = cartProvider.getProductPrice(productId);
                final productCount = cartProvider.getCartCount(productId);

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      productName.isEmpty ? 'Product not found' : productName,
                    ),
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Checkout Successful'),
                content: Text('Thank you for your purchase!'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
          child: Text('Proceed to Payment'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            backgroundColor: Colors.green,
          ),
        ),
      ),
    );
  }
}
