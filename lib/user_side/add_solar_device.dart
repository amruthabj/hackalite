import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddSolarDevicePage extends StatefulWidget {
  const AddSolarDevicePage({Key? key}) : super(key: key);

  @override
  _AddSolarDevicePageState createState() => _AddSolarDevicePageState();
}

class _AddSolarDevicePageState extends State<AddSolarDevicePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _efficiencyController = TextEditingController();
  final TextEditingController _installDateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String selectedDuration = 'Weekly'; // Default to weekly
  String userId = ''; // Store the user ID

  @override
  void initState() {
    super.initState();
    getCurrentUser(); // Fetch the current user ID when the page loads
  }

  // Function to get the current logged-in user's ID
  Future<void> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        userId = user.uid; // Set the userId with the current user's UID
      });
    } else {
      // Handle the case where no user is logged in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
    }
  }

  void _addDevice() async {
    final name = _nameController.text;
    final type = _typeController.text;
    final capacity = double.tryParse(_capacityController.text);
    final efficiency = double.tryParse(_efficiencyController.text);
    final installDate = _installDateController.text;
    final location = _locationController.text;

    if (name.isNotEmpty && type.isNotEmpty && capacity != null && efficiency != null && userId.isNotEmpty) {
      // Create a new solar device document in Firestore
      await FirebaseFirestore.instance.collection('solar_devices').add({
        'userId': userId, // Store the user ID
        'name': name,
        'type': type,
        'capacity': capacity,
        'efficiency': efficiency,
        'installationDate': installDate,
        'location': location,
      });

      // Clear the text fields after successful addition
      _nameController.clear();
      _typeController.clear();
      _capacityController.clear();
      _efficiencyController.clear();
      _installDateController.clear();
      _locationController.clear();

      // Optionally show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Solar device added successfully!')),
      );

      // Navigate back or perform any other actions
      Navigator.of(context).pop();
    } else {
      // Show error if fields are not valid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields correctly.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Solar Device'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Device Name'),
            ),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(labelText: 'Type'),
            ),
            TextField(
              controller: _capacityController,
              decoration: InputDecoration(labelText: 'Capacity (kW)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _efficiencyController,
              decoration: InputDecoration(labelText: 'Efficiency (%)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _installDateController,
              decoration: InputDecoration(labelText: 'Installation Date (YYYY-MM-DD)'),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addDevice,
              child: Text('Add Device'),
            ),
          ],
        ),
      ),
    );
  }
}
