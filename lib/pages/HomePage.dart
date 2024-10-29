import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modern_landscaping/checkout/Cart.dart';
import 'package:modern_landscaping/pages/Body.dart';
import 'package:modern_landscaping/pages/CategorySelectionPage.dart';
import 'package:modern_landscaping/pages/Location.dart';
import 'package:modern_landscaping/pages/SignInPage.dart';
import 'package:modern_landscaping/provider/CartProvider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,
            ),
          ],
        ),
        actions: [
          Consumer<CartProvider>(builder: (context, cartProvider, child) {
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart, size: 24),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Cart()),
                    );
                  },
                ),
                if (cartProvider.cartCount > 0)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 8,
                      ),
                      child: Center(
                        child: Text(
                          '${cartProvider.cartCount}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Body(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/logo.png',
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.category, color: Colors.blue),
              title: Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CategorySelectionPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.location_city, color: Colors.blue),
              title: Text(
                'Locations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Location()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
