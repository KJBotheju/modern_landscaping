import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  final List<String> _locations = [];
  List<String> _filteredLocations = [];
  String _searchQuery = '';
  String? _selectedLocation;
  List<Map<String, dynamic>> _userDetails = [];
  bool _isLoading = true;
  bool _showLocations = false;

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('userType', isNotEqualTo: 'Customer')
          .where('location', isNotEqualTo: null)
          .get();

      final distinctLocations = querySnapshot.docs
          .map((doc) => doc['location'] as String)
          .toSet()
          .toList();

      setState(() {
        _locations.addAll(distinctLocations);
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching locations: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterLocations(String query) {
    setState(() {
      _searchQuery = query;
      _showLocations = query.isNotEmpty;
      _filteredLocations = _locations
          .where((location) =>
              location.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectLocation(String location) async {
    final userDetailsSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('location', isEqualTo: location)
        .where('userType', isNotEqualTo: 'Customer')
        .get();

    final List<Map<String, dynamic>> userDetails = userDetailsSnapshot.docs
        .map((doc) => {
              'username': doc['username'],
              'number': doc['number'],
              'userType': doc['userType'],
            })
        .toList();

    setState(() {
      _userDetails = userDetails;
      _selectedLocation = location;
      _showLocations = false;
      _searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Select Location',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 215, 211, 211),
              Color.fromARGB(255, 242, 249, 238),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Search Location',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        onChanged: _filterLocations,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_showLocations && _filteredLocations.isNotEmpty)
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: _filteredLocations.length,
                          itemBuilder: (context, index) {
                            final location = _filteredLocations[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 8,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                title: Text(
                                  location,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                ),
                                onTap: () => _selectLocation(location),
                              ),
                            );
                          },
                        ),
                      )
                    else if (_showLocations && _filteredLocations.isEmpty)
                      const Text(
                        'No locations found.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (_userDetails.isNotEmpty) ...[
                      Text(
                        _selectedLocation ?? '',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _userDetails.length,
                        itemBuilder: (context, index) {
                          final user = _userDetails[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Text(
                                user['userType'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(
                                'Name: ${user['username']}\nNumber: ${user['number']}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}
