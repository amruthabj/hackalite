import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartvolt1/user_side/applications used.dart'; // Import your RoomAppliancesPage here

class ViewRoomsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Rooms'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No rooms available'));
          }

          var rooms = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              var roomId = rooms[index].id;

              return _buildRoomCard(context, roomId);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddRoomDialog(context); // Show dialog to add a room
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget _buildRoomCard(BuildContext context, String roomId) {
    return GestureDetector(
      onTap: () {
        // Navigate to RoomAppliancesPage with roomId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoomAppliancesPage(roomId: roomId),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.room, size: 50, color: Colors.blueAccent), // Icon or image
            SizedBox(height: 10),
            Text(
              roomId, // Display the roomId
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Function to show the dialog to add a room
  void _showAddRoomDialog(BuildContext context) {
    final TextEditingController roomNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Room'),
          content: TextField(
            controller: roomNameController,
            decoration: InputDecoration(
              labelText: 'Room Name',
              hintText: 'Enter the name of the room',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addRoomToFirestore(roomNameController.text.trim());
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Function to add the room to Firestore with the room name as document ID
  Future<void> _addRoomToFirestore(String roomName) async {
    if (roomName.isNotEmpty) {
      await FirebaseFirestore.instance.collection('rooms').doc(roomName).set({
        'description': '', // You can add a description or leave it empty
        'created_at': Timestamp.now(),
        'user_id': FirebaseAuth.instance.currentUser?.uid,
      });
    }
  }
}
