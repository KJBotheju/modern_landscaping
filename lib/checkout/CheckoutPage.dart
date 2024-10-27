// checkout_page.dart

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
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Proceed to payment or confirmation logic
            // Here, you can implement your payment processing logic
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
                      Navigator.of(context).pop(); // Go back to cart page
                    },
                  ),
                ],
              ),
            );
          },
          child: Text('Proceed to Payment'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            backgroundColor: Colors.green, // Button color
          ),
        ),
      ),
    );
  }
}
