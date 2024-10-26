// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:modern_landscaping/products/ProductDetailPage.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final List<Map<String, String>> _products = [
    {
      'image': 'assets/images/product1.jpg',
      'name': 'Stainless Steel Bench',
      'price': 'Rs 600',
    },
    {
      'image': 'assets/images/product2.png',
      'name': 'Decorative Plant',
      'price': 'Rs 500',
    },
    {
      'image': 'assets/images/product3.jpg',
      'name': 'Decorative Plant 2',
      'price': 'Rs 300',
    },
    {
      'image': 'assets/images/product4.jpg',
      'name': 'Decorative Plant 3',
      'price': 'Rs 300',
    },
    {
      'image': 'assets/images/product1.jpg',
      'name': 'Stainless Steel Bench',
      'price': 'Rs 600',
    },
    {
      'image': 'assets/images/product2.png',
      'name': 'Decorative Plant',
      'price': 'Rs 500',
    },
    {
      'image': 'assets/images/product3.jpg',
      'name': 'Decorative Plant 2',
      'price': 'Rs 300',
    },
    {
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

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.7,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: GestureDetector(
                    onTap: () => _showIcons(index),
                    child: Image.asset(
                      product['image']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              if (_selectedProductIndex == index) ...[
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => print('camera click.'),
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
                    onTap: () => print('cart click.'),
                    child: Icon(
                      Icons.shopping_cart,
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          product['price']!,
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
      physics: NeverScrollableScrollPhysics(),
    );
  }
}
