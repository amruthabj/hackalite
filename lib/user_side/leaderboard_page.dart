import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Energy Usage Leaderboard'),
        backgroundColor: Colors.blue,
      ),
      body: LeaderboardList(),
    );
  }
}

class LeaderboardList extends StatelessWidget {
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<List<Map<String, dynamic>>> _fetchLeaderboardData() async {
    // Fetch all users
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

    List<Map<String, dynamic>> leaderboardData = [];

    for (var userDoc in usersSnapshot.docs) {
      String userId = userDoc.id;
      String userName = userDoc['name'];

      // Calculate total energy used by this user
      double totalEnergyUsed = await _calculateTotalEnergyUsed(userId);
      double energySaved = 1000 - totalEnergyUsed; // Assuming 1000 is a baseline for energy saved

      leaderboardData.add({
        'name': userName,
        'totalEnergyUsed': totalEnergyUsed,
        'energySaved': energySaved,
        'averageEnergyUsed': totalEnergyUsed / 12, // Assuming it's calculated monthly
        'userId': userId,
      });
    }

    // Sort users by total energy used (ascending)
    leaderboardData.sort((a, b) => a['totalEnergyUsed'].compareTo(b['totalEnergyUsed']));

    return leaderboardData;
  }

  Future<double> _calculateTotalEnergyUsed(String userId) async {
    double totalEnergy = 0.0;

    // Fetch all rooms for the user
    QuerySnapshot roomsSnapshot = await FirebaseFirestore.instance
        .collection('rooms')
        .where('user_id', isEqualTo: userId) // Ensure to get rooms for this user
        .get();

    for (var roomDoc in roomsSnapshot.docs) {
      // Fetch appliances in the room
      QuerySnapshot appliancesSnapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomDoc.id) // Get appliances for this room
          .collection('appliances')
          .get();

      for (var applianceDoc in appliancesSnapshot.docs) {
        // Assuming 'energyUsedMonthly' is stored as a field in each appliance document
        double energyUsed = (applianceDoc.data() as Map<String, dynamic>)['energyUsedMonth']?.toDouble() ?? 0.0;
        totalEnergy += energyUsed;
      }
    }

    return totalEnergy;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchLeaderboardData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final leaderboardData = snapshot.data ?? [];

        // Adding static values
        final staticData = [
          {'name': 'Caroline', 'totalEnergyUsed': 500.5, 'energySaved': 499.5, 'averageEnergyUsed': 90.7},
          {'name': 'Amrutha', 'totalEnergyUsed': 585.0, 'energySaved': 315.0, 'averageEnergyUsed': 100.4},
          {'name': 'Aditya', 'totalEnergyUsed': 650.3, 'energySaved': 249.7, 'averageEnergyUsed': 250.5},
        ];

        // Combine dynamic data with static data
        final combinedData = leaderboardData + staticData;

        return ListView.builder(
          itemCount: combinedData.length,
          itemBuilder: (context, index) {
            final data = combinedData[index];
            Color cardColor;

            // Set different colors for the first three users
            if (index == 0) {
              cardColor = Colors.yellow.shade100;
            } else if (index == 1) {
              cardColor = Colors.orange.shade100;
            } else if (index == 2) {
              cardColor = Colors.red.shade100;
            } else {
              cardColor = Colors.white;
            }

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              elevation: 3,
              color: cardColor, // Dynamic background color
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade700,
                  child: Text(
                    '${index + 1}', // Rank number
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  data['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Energy Saved: ${data['energySaved'].toStringAsFixed(2)} kWh', // Display energy saved
                      style: TextStyle(color: Colors.green),
                    ),
                    Text(
                      'Avg. Energy Used: ${data['averageEnergyUsed'].toStringAsFixed(2)} kWh', // Display average energy used
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  ],
                ),
                trailing: Text(
                  '${data['totalEnergyUsed'].toStringAsFixed(2)} kWh', // Displaying energy usage
                  style: TextStyle(fontSize: 16, color: Colors.green),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
