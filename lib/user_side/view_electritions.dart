import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add-appointment_page.dart';

class ViewElectriciansPage extends StatefulWidget {
  @override
  _ViewElectriciansPageState createState() => _ViewElectriciansPageState();
}

class _ViewElectriciansPageState extends State<ViewElectriciansPage> {
  Stream<List<DocumentSnapshot>>? stream;

  @override
  void initState() {
    super.initState();
    stream = getAllElectricians();
  }

  Stream<List<DocumentSnapshot>> getAllElectricians() {
    return FirebaseFirestore.instance.collection('electricians').snapshots().map(
          (snapshot) {
        return snapshot.docs;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Electricians 🌟'), // Title with emoji
        centerTitle: true,
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching electricians'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> electricians = snapshot.data!;
          if (electricians.isEmpty) {
            return Center(child: Text('No electricians found'));
          }

          return ListView.builder(
            itemCount: electricians.length,
            itemBuilder: (context, index) {
              var electrician = electricians[index];
              String electricianName = electrician['name'] ?? 'No Name';
              String contact = electrician['contact'] ?? 'No Contact';
              String experience = electrician['experience'] ?? 'No Experience';
              String hourlyRate = electrician['hourlyRate'] ?? 'No Rate';

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    electricianName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // Bold and larger font
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.phone, color: Colors.blue), // Phone icon
                          SizedBox(width: 8),
                          Text('Contact: $contact'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.work, color: Colors.green), // Work icon
                          SizedBox(width: 8),
                          Text('Experience: $experience years'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.attach_money, color: Colors.orange), // Money icon
                          SizedBox(width: 8),
                          Text('Hourly Rate: \$${hourlyRate}'), // Display hourly rate
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the appointment page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddAppointmentPage(
                                electricianId: electrician.id,
                                electricianName: electricianName,
                              ),
                            ),
                          );
                        },
                        child: Text('📅 Book Appointment'), // Button text with emoji
                      ),
                    ],
                  ),

                ),
              );
            },
          );
        },
      ),
    );
  }
}
