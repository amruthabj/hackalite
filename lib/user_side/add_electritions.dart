import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddElectricianPage extends StatefulWidget {
  @override
  _AddElectricianPageState createState() => _AddElectricianPageState();
}

class _AddElectricianPageState extends State<AddElectricianPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _hourlyRateController = TextEditingController(); // New controller

  Future<void> _addElectrician() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String contact = _contactController.text;
      String experience = _experienceController.text;
      String hourlyRate = _hourlyRateController.text; // Get hourly rate

      // Add electrician to Firestore
      await FirebaseFirestore.instance.collection('electricians').add({
        'name': name,
        'contact': contact,
        'experience': experience,
        'hourlyRate': hourlyRate, // Add hourly rate to Firestore
      });

      // Clear the text fields
      _nameController.clear();
      _contactController.clear();
      _experienceController.clear();
      _hourlyRateController.clear(); // Clear the hourly rate field

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Electrician added successfully')),
      );

      // Navigate back after adding
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Electrician'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the electrician\'s name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(labelText: 'Contact'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact information';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _experienceController,
                decoration: InputDecoration(labelText: 'Experience (in years)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter years of experience';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _hourlyRateController, // New field for hourly rate
                decoration: InputDecoration(labelText: 'Hourly Rate'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the hourly rate';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addElectrician,
                child: Text('Add Electrician'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
