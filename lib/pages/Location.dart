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

  // Fetch distinct locations from Firestore
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
        _isLoading = false; // Stop loading
      });
    } catch (e) {
      print("Error fetching locations: $e");
      setState(() {
        _isLoading = false; // Stop loading even on error
      });
    }
  }

  // Filter locations based on search query and show the locations list
  void _filterLocations(String query) {
    setState(() {
      _searchQuery = query;
      _showLocations = query.isNotEmpty; // Show list only if query is not empty
      _filteredLocations = _locations
          .where((location) =>
              location.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Fetch and display user details for the selected location, then hide locations list
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
      _showLocations = false; // Hide locations list after selection
      _searchQuery = ''; // Clear search query
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Loading indicator
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search Location',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _filterLocations,
                  ),
                  const SizedBox(height: 20),
                  if (_showLocations && _filteredLocations.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredLocations.length,
                      itemBuilder: (context, index) {
                        final location = _filteredLocations[index];
                        return Card(
                          elevation: 4.0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(location),
                            onTap: () => _selectLocation(location),
                          ),
                        );
                      },
                    )
                  else if (_showLocations && _filteredLocations.isEmpty)
                    const Text('No locations found.'),
                  const SizedBox(height: 20),
                  if (_userDetails.isNotEmpty) ...[
                    Text(
                      '$_selectedLocation',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _userDetails.length,
                      itemBuilder: (context, index) {
                        final user = _userDetails[index];
                        return Card(
                          elevation: 4.0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(user['userType']),
                            subtitle: Text(
                                'Number: ${user['username']} \nType: ${user['number']}'),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
