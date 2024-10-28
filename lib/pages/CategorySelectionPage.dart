import 'package:flutter/material.dart';
import 'package:modern_landscaping/products/products.dart';

class CategorySelectionPage extends StatelessWidget {
  CategorySelectionPage({Key? key}) : super(key: key);

  final List<String> categories = [
    'Furniture',
    'Plants',
    'Tree',
    // Add more categories as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categories[index]),
            onTap: () {
              // Navigate to Products page with the selected category
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Products(category: categories[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
