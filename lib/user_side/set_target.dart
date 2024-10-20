import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SetTargetPage extends StatefulWidget {
  @override
  _SetTargetPageState createState() => _SetTargetPageState();
}

class _SetTargetPageState extends State<SetTargetPage> {
  final TextEditingController _targetController = TextEditingController();
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

  // Function to save target to Firestore
  void saveTarget() async {
    double? targetValue = double.tryParse(_targetController.text);

    if (targetValue != null && targetValue > 0) {
      if (userId.isNotEmpty) {
        // Save the target to Firestore under the current user's document
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'targetValue': targetValue,
          'targetDuration': selectedDuration,
        }, SetOptions(merge: true));

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Target Set Successfully',
              style: TextStyle(color: Colors.white), // Text color
            ),
            backgroundColor: Colors.green, // Background color
            behavior: SnackBarBehavior.floating, // Optional: Makes the SnackBar float
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
            ),
          ),
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User ID not found')),
        );
      }
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid target')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Energy Bill Target'),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section at the top
            Center(
              child: Image.asset(
                'images/target.png', // Ensure you have this image in the assets folder
                height: 350, // You can adjust the size based on your image
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20), // Space below the image
            Text(
              'Set your energy target:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 20),
            // Dropdown for selecting weekly or monthly
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                underline: SizedBox(), // Remove the underline
                value: selectedDuration,
                onChanged: (newValue) {
                  setState(() {
                    selectedDuration = newValue!;
                  });
                },
                items: ['Weekly', 'Monthly'].map((duration) {
                  return DropdownMenuItem<String>(
                    value: duration,
                    child: Text(duration),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            // Input for entering the target value
            TextField(
              controller: _targetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Target Amount (₹)',
                labelStyle: TextStyle(color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 2.0),
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(
                  Icons.monetization_on,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 30),
            // Save button
            Center(
              child: ElevatedButton(
                onPressed: saveTarget,
                child: Text('Save Target'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5, // Add shadow
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
