import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modern_landscaping/provider/CartProvider.dart';
import 'package:modern_landscaping/checkout/CheckoutPage.dart'; // Import the CheckoutPage

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
                      color: Colors.green, // Correct way to set text color
                    ),
                  ),
                  backgroundColor:
                      Colors.white, // Optional: Customize background
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Scrollable product list
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
                        subtitle: Text(
                            'Price: $productPrice\nQuantity: $productCount'),
                        trailing: Text(
                          'Total: Rs ${double.parse(productPrice.replaceAll('Rs ', '')) * productCount}',
                        ),
                      );
                    },
                  )
                : Center(child: Text('Your cart is empty!')),
          ),

          // Conditionally show the checkout button if the cart is not empty
          if (cartProvider.distinctProductCount > 0)
            Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to CheckoutPage
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
                  backgroundColor: Colors.green, // Button color
                ),
              ),
            ),
        ],
      ),
    );
  }
}
