// ignore_for_file: file_names, use_super_parameters, prefer_final_fields, prefer_const_constructors, use_build_context_synchronously, sort_child_properties_last, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_landscaping/pages/HomePage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _selectedUserType;
  String? _selectedLocation;

  Future<void> _signUp() async {
    try {
      if (_usernameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _numberController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _confirmPasswordController.text.isEmpty ||
          _selectedUserType == null ||
          _selectedLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill in all fields.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Passwords do not match.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await _firestore.collection('Users').doc(userCredential.user!.uid).set({
        'userId': userCredential.user!.uid,
        'username': _usernameController.text,
        'email': _emailController.text,
        'number': _numberController.text,
        'userType': _selectedUserType,
        'location': _selectedLocation,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign Up successful!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 200,
                height: 180,
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: TextField(
                  controller: _usernameController,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: "Name",
                    prefixIcon: Icon(Icons.person_outline),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: TextField(
                  controller: _emailController,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.person_outline),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: TextField(
                  controller: _numberController,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    prefixIcon: Icon(Icons.phone),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: DropdownButtonFormField<String>(
                  value: _selectedUserType,
                  items: [
                    'Customer',
                    'Plant Distributor',
                    'Garden Decoration Item Distributor',
                    'Landscape Architecture'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedUserType = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'User Type',
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: DropdownButtonFormField<String>(
                  value: _selectedLocation,
                  items: [
                    'Colombo',
                    'Kandy',
                    'Galle',
                    'Matara',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedLocation = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Location',
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: TextField(
                  controller: _passwordController,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: "Password",
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.2),
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: TextField(
                  controller: _confirmPasswordController,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.2),
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 201, 201, 201),
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  obscureText: !_isConfirmPasswordVisible,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _signUp(),
                child: Text(
                  'Signup',
                  style: TextStyle(color: Colors.black),
                ),
                style: TextButton.styleFrom(
                  minimumSize: Size(300, 50),
                  backgroundColor: Colors.blue[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
