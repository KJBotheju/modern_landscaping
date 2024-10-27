import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modern_landscaping/firebase_options.dart';
import 'package:modern_landscaping/pages/SplashScreen.dart';
import 'package:modern_landscaping/provider/CartProvider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        title: 'Modern Landscaping',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 74, 224, 81)),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
