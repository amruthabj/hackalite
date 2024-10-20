import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartvolt1/user_side/add_new_applaince.dart'; // Import your AddAppliancePage here

class RoomAppliancesPage extends StatefulWidget {
  final String roomId; // Pass the room ID to fetch specific room data

  RoomAppliancesPage({required this.roomId});

  @override
  _RoomAppliancesPageState createState() => _RoomAppliancesPageState();
}

class _RoomAppliancesPageState extends State<RoomAppliancesPage> {
  Map<String, bool> applianceStatus = {}; // Local map to store the isOn status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Appliances'),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rooms')
            .doc(widget.roomId)
            .collection('appliances') // Fetch appliances as a subcollection
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildNoAppliancesView();
          }

          var appliances = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: appliances.length,
            itemBuilder: (context, index) {
              var appliance = appliances[index].data() as Map<String, dynamic>;
              String applianceId = appliances[index].id;

              // Handle null values using the null-aware operator (??)
              bool isOn = appliance['isOn'] ?? false;
              double energyUsedToday = appliance['energyUsedToday']?.toDouble() ?? 0.0;
              double energyUsedWeek = appliance['energyUsedWeek']?.toDouble() ?? 0.0;
              double energyUsedMonth = appliance['energyUsedMonth']?.toDouble() ?? 0.0;

              // Initialize the local appliance status map
              applianceStatus[applianceId] = applianceStatus[applianceId] ?? isOn;

              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  leading: Icon(
                    Icons.power,
                    color: applianceStatus[applianceId]! ? Colors.green : Colors.red,
                  ),
                  title: Text(
                    appliance['applianceType'] ?? 'Unknown Appliance',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Energy Used Today: $energyUsedToday kWh',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      Text(
                        'Energy Used This Week: $energyUsedWeek kWh',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      Text(
                        'Energy Used This Month: $energyUsedMonth kWh',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Status: ${applianceStatus[applianceId]! ? 'On' : 'Off'}',
                        style: TextStyle(
                            color: applianceStatus[applianceId]! ? Colors.green : Colors.red),
                      ),
                    ],
                  ),
                  trailing: Switch(
                    value: applianceStatus[applianceId]!,
                    onChanged: (bool value) {
                      setState(() {
                        // Update the local state
                        applianceStatus[applianceId] = value;
                      });

                      // Update the value in Firestore
                      FirebaseFirestore.instance
                          .collection('rooms')
                          .doc(widget.roomId)
                          .collection('appliances')
                          .doc(applianceId)
                          .update({'isOn': value})
                          .then((_) {
                        print('isOn status updated successfully');
                      })
                          .catchError((error) {
                        print('Failed to update isOn status: $error');
                      });
                    },
                    activeColor: Colors.teal,
                  ),
                ),
              );
            },
          );
        },
      ),
      // Add FloatingActionButton to add new appliances
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAppliancePage(roomId: widget.roomId),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }

  // Widget to show when no appliances are available
  Widget _buildNoAppliancesView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning, size: 60, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'No appliances available currently',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAppliancePage(roomId: widget.roomId),
                ),
              );
            },
            child: Text('Add Appliance'),
          ),
        ],
      ),
    );
  }
}
