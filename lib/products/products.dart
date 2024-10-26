import 'package:flutter/material.dart';
import 'package:modern_landscaping/products/ProductDetailPage.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  // Sample product data
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
      'name': 'Bench Set',
      'price': 'Rs 300',
    },
    {
      'image': 'assets/images/product4.jpg',
      'name': 'Modern Outdoor Chair',
      'price': 'Rs 300',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two products in the same row
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.7, // Adjust the aspect ratio for the grid items
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.asset(
                    product['image']!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to the product detail page when the name or price is tapped
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
                      SizedBox(height: 4), // Optional spacing
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
            ],
          ),
        );
      },
      shrinkWrap: true, // Makes the GridView size based on its children
      physics:
          NeverScrollableScrollPhysics(), // Prevents GridView from scrolling
    );
  }
}
