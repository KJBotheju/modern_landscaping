import 'package:flutter/material.dart';
import 'package:modern_landscaping/products/products.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  final List<String> _locations = [
    'Garden',
    'Colombo',
    'Matara',
    'Kandy',
    // Add more locations as needed
  ];

  List<String> _filteredLocations = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredLocations = []; // Start with an empty list
  }

  void _filterLocations(String query) {
    setState(() {
      _searchQuery = query;
      _filteredLocations = _locations
          .where((location) =>
              location.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectLocation(String location) {
    // Handle the selection of a location and navigate to Products
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Products(location: location), // Pass selected location
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: SingleChildScrollView(
        // Make the body scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search Location',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterLocations,
            ),
            const SizedBox(height: 20),
            // Display attractive message or image initially
            _searchQuery.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 80,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Explore Locations',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Start typing to find a location!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true, // Use shrinkWrap to fit the ListView
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable scrolling of ListView
                    itemCount: _filteredLocations.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(_filteredLocations[index]),
                          onTap: () =>
                              _selectLocation(_filteredLocations[index]),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
