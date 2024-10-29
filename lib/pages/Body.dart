// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:modern_landscaping/products/allproducts.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final List<String> _slides = [
    'assets/images/slideshow1.png',
    'assets/images/slideshow2.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider.builder(
              itemCount: _slides.length,
              itemBuilder: (context, index, realIndex) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    _slides[index],
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                );
              },
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                enlargeCenterPage: false,
                aspectRatio: 2.0,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Products',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ALLProducts(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
