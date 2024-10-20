import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartvolt1/user_side/add_solar_device.dart'; // Adjust the import for your AddSolarDevicePage
import 'package:smartvolt1/user_side/solar_predictor.dart'; // Import your SolarEnergyPredictorPage here

class ViewSolarDevicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Solar Devices'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('solar_devices')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid) // Filter by current user ID
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No solar devices available'));
          }

          var solarDevices = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: solarDevices.length,
            itemBuilder: (context, index) {
              var deviceId = solarDevices[index].id;
              var deviceData = solarDevices[index].data() as Map<String, dynamic>;

              return _buildDeviceCard(context, deviceId, deviceData);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AddSolarDevicePage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSolarDevicePage(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget _buildDeviceCard(BuildContext context, String deviceId, Map<String, dynamic> deviceData) {
    return GestureDetector(
      onTap: () {
        // Navigate to SolarEnergyPredictorPage with device details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnergyPredictionPage(), // Pass device data
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.solar_power, size: 50, color: Colors.blueAccent), // Use a solar device icon
            SizedBox(height: 10),
            Text(
              deviceData['name'] ?? 'Unknown Device', // Display the device name or a placeholder
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              'Type: ${deviceData['type'] ?? 'N/A'}', // Display the device type
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 5),
            Text(
              'Location: ${deviceData['location'] ?? 'N/A'}', // Display the location
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
