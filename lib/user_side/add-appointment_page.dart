import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddAppointmentPage extends StatefulWidget {
  final String electricianId;
  final String electricianName;

  AddAppointmentPage({required this.electricianId, required this.electricianName});

  @override
  _AddAppointmentPageState createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _jobTypeController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  Future<void> _addAppointment() async {
    if (_formKey.currentState!.validate()) {
      String date = _dateController.text;
      String time = _timeController.text;
      String jobType = _jobTypeController.text;
      String details = _detailsController.text;

      // Get the current user's ID
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      // Add appointment to Firestore
      await FirebaseFirestore.instance.collection('appointments').add({
        'electricianId': widget.electricianId,
        'electricianName': widget.electricianName,
        'userId': userId, // Store the current user ID
        'date': date,
        'time': time,
        'jobType': jobType,
        'details': details,
        'status': 'Pending', // Set initial status
      });

      // Clear the text fields
      _dateController.clear();
      _timeController.clear();
      _jobTypeController.clear();
      _detailsController.clear();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment booked successfully')),
      );

      // Navigate back after adding
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment with ${widget.electricianName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the appointment date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(labelText: 'Time (HH:MM)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the appointment time';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _jobTypeController,
                decoration: InputDecoration(labelText: 'Type of Job'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the type of job';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _detailsController,
                decoration: InputDecoration(labelText: 'Additional Details'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter additional details';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addAppointment,
                child: Text('Book Appointment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
