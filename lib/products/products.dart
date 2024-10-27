import 'dart:async';
import 'package:flutter/material.dart';
import 'package:modern_landscaping/products/ProductDetailPage.dart';
import 'package:modern_landscaping/provider/CartProvider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final List<Map<String, dynamic>> _products = [
    {
      'id': 1,
      'image': 'assets/images/product1.jpg',
      'name': 'Steel Bench',
      'price': 'Rs 600',
    },
    {
      'id': 2,
      'image': 'assets/images/product2.png',
      'name': 'Decorative Plant',
      'price': 'Rs 500',
    },
    {
      'id': 3,
      'image': 'assets/images/product3.jpg',
      'name': 'Decorative Plant 2',
      'price': 'Rs 300',
    },
    {
      'id': 4,
      'image': 'assets/images/product4.jpg',
      'name': 'Decorative Plant 3',
      'price': 'Rs 300',
    },
  ];

  int? _selectedProductIndex;
  Timer? _timer;

  void _showIcons(int index) {
    setState(() {
      _selectedProductIndex = index;
    });

    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _selectedProductIndex = null;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleCart(int productId, String productName, String productPrice) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.toggleItemInCart(productId, productName, productPrice);
  }

  void _navigateToProductDetail(
      BuildContext context, Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          image: product['image'],
          name: product['name'],
          price: product['price'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 29.0,
        childAspectRatio: 0.7,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        final cartProvider = Provider.of<CartProvider>(context);
        final itemCount = cartProvider.getCartCount(product['id']);

        return Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: GestureDetector(
                  onTap: () => _showIcons(index),
                  child: Image.asset(
                    product['image'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (_selectedProductIndex == index) ...[
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      launch('https://buddhii.github.io/AR/');
                    },
                    child: Icon(
                      Icons.camera_alt,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => _toggleCart(
                      product['id'],
                      product['name'],
                      product['price'],
                    ),
                    child: Icon(
                      itemCount > 0
                          ? Icons.shopping_cart
                          : Icons.shopping_cart_outlined,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _navigateToProductDetail(context, product),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          product['price'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
