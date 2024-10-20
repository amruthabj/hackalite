// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class TotalAmountPage extends StatefulWidget {
//   @override
//   _TotalAmountPageState createState() => _TotalAmountPageState();
// }
//
// class _TotalAmountPageState extends State<TotalAmountPage> {
//   double totalAmount = 0.0; // Initialize total amount
//   double ratePerKWh = 0.12; // Default rate per kWh
//   final TextEditingController _rateController = TextEditingController(); // Controller for the TextField
//
//   @override
//   void initState() {
//     super.initState();
//     calculateTotalAmount();
//   }
//
//   Future<void> calculateTotalAmount() async {
//     // Fetch all room data from Firestore
//     QuerySnapshot roomsSnapshot = await FirebaseFirestore.instance
//         .collection('rooms') // Ensure this matches your collection name
//         .get();
//
//     double totalEnergyUsed = 0.0; // Initialize total energy used
//
//     for (var roomDoc in roomsSnapshot.docs) {
//       var roomData = roomDoc.data() as Map<String, dynamic>;
//
//       // Safely retrieve the appliances list
//       List<dynamic> appliances = roomData['appliances'] is List<dynamic>
//           ? roomData['appliances']
//           : []; // Use an empty list if the key doesn't exist or is not a list
//
//       // Sum up energy used for each appliance in the room
//       for (var appliance in appliances) {
//         totalEnergyUsed += appliance['energyUsedMonth'] ?? 0.0; // Add up energy used today, default to 0 if null
//       }
//     }
//
//
//     // Calculate total amount based on the total energy used
//     setState(() {
//       totalAmount = totalEnergyUsed * ratePerKWh; // Calculate bill amount
//     });
//   }
//
//   void updateRate() {
//     // Validate and update the rate per kWh
//     double? newRate = double.tryParse(_rateController.text);
//     if (newRate != null && newRate > 0) {
//       setState(() {
//         ratePerKWh = newRate; // Update the rate
//         calculateTotalAmount(); // Recalculate total amount with new rate
//       });
//     } else {
//       // Show error message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter a valid rate')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Total Amount'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Enter Rate per kWh:',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: _rateController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Enter rate per kWh',
//                 ),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: updateRate,
//                 child: Text('Update Rate'),
//                 style: ElevatedButton.styleFrom(),
//               ),
//               SizedBox(height: 40),
//               Text(
//                 'Total Electricity Bill Amount:',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 '₹${totalAmount.toStringAsFixed(2)}', // Display total amount formatted to 2 decimal places
//                 style: TextStyle(fontSize: 24, color: Colors.teal),
//               ),
//               SizedBox(height: 40),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context); // Navigate back
//                 },
//                 child: Text('Back'),
//                 style: ElevatedButton.styleFrom(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class TotalAmountPage extends StatefulWidget {
//   @override
//   _TotalAmountPageState createState() => _TotalAmountPageState();
// }
//
// class _TotalAmountPageState extends State<TotalAmountPage> {
//   double totalAmount = 0.0; // Initialize total amount
//   double ratePerKWh = 0.12; // Default rate per kWh
//   final TextEditingController _rateController =
//       TextEditingController(); // Controller for the TextField
//
//   @override
//   void initState() {
//     super.initState();
//     calculateTotalAmount();
//   }
//
//   Future<void> calculateTotalAmount() async {
//     // Fetch all room data from Firestore
//     QuerySnapshot roomsSnapshot = await FirebaseFirestore.instance
//         .collection('rooms') // Ensure this matches your collection name
//         .get();
//
//     double totalEnergyUsed = 0.0; // Initialize total energy used
//
//     for (var roomDoc in roomsSnapshot.docs) {
//       var roomData = roomDoc.data() as Map<String, dynamic>;
//
//       // Safely retrieve the appliances list
//       List<dynamic> appliances = roomData['appliances'] is List<dynamic>
//           ? roomData['appliances']
//           : []; // Use an empty list if the key doesn't exist or is not a list
//
//       // Sum up energy used for each appliance in the room
//       for (var appliance in appliances) {
//         totalEnergyUsed += appliance['energyUsedMonth'] ??
//             0.0; // Add up energy used today, default to 0 if null
//       }
//     }
//
//     // Calculate total amount based on the total energy used
//     setState(() {
//       totalAmount = totalEnergyUsed * ratePerKWh; // Calculate bill amount
//     });
//   }
//
//   void updateRate() {
//     // Validate and update the rate per kWh
//     double? newRate = double.tryParse(_rateController.text);
//     if (newRate != null && newRate > 0) {
//       setState(() {
//         ratePerKWh = newRate; // Update the rate
//         calculateTotalAmount(); // Recalculate total amount with new rate
//       });
//     } else {
//       // Show error message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter a valid rate')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Electricity Bill Calculator'),
//         backgroundColor: Colors.teal[700],
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 16.0),
//                 child: Image.asset(
//                   'images/bills.png', // Update with your asset path
//                   height: 250, // Set height as needed
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Card(
//                 elevation: 8,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Container(
//                   padding: const EdgeInsets.all(20.0),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Colors.white!, Colors.teal[200]!],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//
//                       Text(
//                         'Enter Rate per kWh:',
//                         style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.teal[800]),
//                       ),
//                       SizedBox(height: 10),
//                       TextField(
//                         controller: _rateController,
//                         keyboardType: TextInputType.number,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(color: Colors.teal[800]!),
//                           ),
//                           hintText: 'Enter rate per kWh',
//                           hintStyle: TextStyle(color: Colors.teal[600]),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: updateRate,
//                         child: Text('Update Rate'),
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           backgroundColor: Colors.teal, // Set the background color
//                           foregroundColor: Colors.white, // Set the text color
//                           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Optional padding
//                         ),
//                       ),
//
//                       SizedBox(height: 40),
//                       Text(
//                         'Total Electricity Bill Amount:',
//                         style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.teal[800]),
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         '₹${totalAmount.toStringAsFixed(2)}', // Display total amount formatted to 2 decimal places
//                         style: TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black54),
//                       ),
//                       SizedBox(height: 40),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.pop(context); // Navigate back
//                         },
//                         child: Text('Back'),
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           backgroundColor: Colors.teal, // Set the background color
//                           foregroundColor: Colors.white, // Set the text color
//                           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                         ),
//
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TotalAmountPage extends StatefulWidget {
  @override
  _TotalAmountPageState createState() => _TotalAmountPageState();
}

class _TotalAmountPageState extends State<TotalAmountPage> {
  double totalAmount = 0.0; // Initialize total amount
  double ratePerKWh = 0.12; // Default rate per kWh
  double targetValue = 0.0; // Target value for the user
  String targetDuration = 'Monthly'; // Target duration (weekly or monthly)
  String userId = ''; // Store the current user's ID
  final TextEditingController _rateController = TextEditingController(); // Controller for the TextField

  @override
  void initState() {
    super.initState();
    fetchUserTarget(); // Fetch user's target
    calculateTotalAmount(); // Calculate total amount
  }

  Future<void> fetchUserTarget() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;

      // Fetch target value and duration from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          targetValue = userDoc['targetValue'] ?? 0.0; // Get target value
          targetDuration = userDoc['targetDuration'] ?? 'Monthly'; // Get target duration
        });
      }
    }
  }

  Future<void> calculateTotalAmount() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;

      // Fetch rooms where the user_id matches the current user
      QuerySnapshot roomsSnapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .where('user_id', isEqualTo: userId) // Filter rooms by current user
          .get();

      double totalEnergyUsed = 0.0; // Initialize total energy used

      // Loop through each room that belongs to the current user
      for (var roomDoc in roomsSnapshot.docs) {
        String roomId = roomDoc.id;

        // Fetch appliances for the current room
        QuerySnapshot appliancesSnapshot = await FirebaseFirestore.instance
            .collection('rooms')
            .doc(roomId)
            .collection('appliances')
            .get();

        // Sum up the energy used for each appliance in the room
        for (var applianceDoc in appliancesSnapshot.docs) {
          var applianceData = applianceDoc.data() as Map<String, dynamic>;

          totalEnergyUsed += applianceData['energyUsedMonth']?.toDouble() ?? 0.0;
          // Add up energy used this month, default to 0 if null
        }
      }

      // Calculate the total amount based on the total energy used
      setState(() {
        totalAmount = totalEnergyUsed * ratePerKWh; // Calculate the total bill amount
      });
    }
  }

  void updateRate() {
    // Validate and update the rate per kWh
    double? newRate = double.tryParse(_rateController.text);
    if (newRate != null && newRate > 0) {
      setState(() {
        ratePerKWh = newRate; // Update the rate
        calculateTotalAmount(); // Recalculate total amount with new rate
      });
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid rate')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the total amount exceeds the target
    bool exceedsTarget = totalAmount > targetValue;

    return Scaffold(
      appBar: AppBar(
        title: Text('Electricity Bill Calculator'),
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView( // Added SingleChildScrollView for scrolling
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Image.asset(
                    'images/bills.png', // Update with your asset path
                    height: 250, // Set height as needed
                    fit: BoxFit.cover,
                  ),
                ),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.blue[100]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Enter Rate per kWh:',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _rateController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blue[800]!),
                            ),
                            hintText: 'Enter rate per kWh',
                            hintStyle: TextStyle(color: Colors.blue[600]),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: updateRate,
                          child: Text('Update Rate'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.blue, // Set the background color
                            foregroundColor: Colors.white, // Set the text color
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Optional padding
                          ),
                        ),
                        SizedBox(height: 40),
                        Text(
                          'Total Electricity Bill Amount:',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          '₹${totalAmount.toStringAsFixed(2)}', // Display total amount formatted to 2 decimal places
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 20),
                        if (exceedsTarget) ...[
                          Text(
                            '⚠️ Exceeds your $targetDuration target of ₹${targetValue.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Navigate back
                          },
                          child: Text('Back'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Colors.blue, // Set the background color
                            foregroundColor: Colors.white, // Set the text color
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
