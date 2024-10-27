import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modern_landscaping/provider/CartProvider.dart';

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              cartProvider.clearCartData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cart cleared successfully!')),
              );
            },
          ),
        ],
      ),
      body: cartProvider.distinctProductCount > 0
          ? ListView.builder(
              itemCount: cartProvider.distinctProductCount,
              itemBuilder: (context, index) {
                final productId =
                    cartProvider.filteredCartItems.keys.elementAt(index);
                final productName = cartProvider.getProductName(productId);
                final productPrice = cartProvider.getProductPrice(productId);
                final productCount = cartProvider.getCartCount(productId);

                return ListTile(
                  title: Text(productName),
                  subtitle:
                      Text('Price: $productPrice\nQuantity: $productCount'),
                  trailing: Text(
                    'Total: Rs ${double.parse(productPrice.replaceAll('Rs ', '')) * productCount}',
                  ),
                );
              },
            )
          : Center(child: Text('Your cart is empty!')),
    );
  }
}
