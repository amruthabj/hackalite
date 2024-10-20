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
      body: Column(
        children: [
          Expanded(child: LeaderboardList()), // Expanded to take up remaining space
          _buildStaticSummarySection(), // Static summary values
        ],
      ),
    );
  }

  // Static values section at the bottom
  Widget _buildStaticSummarySection() {
    return Container(
      color: Colors.blue.shade100,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leaderboard Summary',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem('Top User', 'John Doe'), // Static top user
              _buildSummaryItem('Total Energy Saved', '1500 kWh'), // Static total energy
              _buildSummaryItem('Average Energy Use', '120 kWh'), // Static average energy usage
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: Colors.blueAccent),
        ),
      ],
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

      leaderboardData.add({
        'name': userName,
        'totalEnergyUsed': totalEnergyUsed,
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

        return ListView.builder(
          itemCount: leaderboardData.length,
          itemBuilder: (context, index) {
            final data = leaderboardData[index];

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              elevation: 3,
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
