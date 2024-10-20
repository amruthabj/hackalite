import 'package:flutter/material.dart';
import 'set_target.dart'; // Create this page
import 'total_bill_amount.dart'; // Create this page
import 'view_electritions.dart'; // Correct spelling of electricians
import 'view rooms.dart';
import 'leaderboard_page.dart';
import 'view_solar_devices.dart';// Corrected import for view rooms
import 'package:smartvolt1/user_side/Community/community page.dart'; // Ensure file name is correct

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            SquareImageCard(
              imagePath: 'images/hometarget.png', // Ensure this path is correct
              title: 'Set Target',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SetTargetPage()),
                );
              },
            ),
            SquareImageCard(
              imagePath: 'images/billcalculator.png', // Ensure this path is correct
              title: 'Electricity Bill Calculator',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TotalAmountPage()),
                );
              },
            ),
            SquareImageCard(
              imagePath: 'images/electritions.png', // Ensure this path is correct
              title: 'Electricians',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewElectriciansPage()),
                );
              },
            ),
            SquareImageCard(
              imagePath: 'images/solar.png', // Ensure this path is correct
              title: 'Solar Energy Predictor',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>ViewSolarDevicesPage()), // Change this to the correct page
                );
              },
            ),
            SquareImageCard(
              imagePath: 'images/rooms.png', // Ensure this path is correct
              title: 'View Rooms',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewRoomsPage()),
                );
              },
            ),
            SquareImageCard(
              imagePath: 'images/community.png', // Ensure this path is correct
              title: 'Community',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QueryListPage()),
                );
              },
            ),
            SquareImageCard(
              imagePath: 'images/leaderboard.png', // Ensure this path is correct
              title: 'Leaderboard',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LeaderboardPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SquareImageCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;

  const SquareImageCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            // Image at the top that fills the square
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover, // Ensures the image covers the box
                  ),
                ),
              ),
            ),
            // Text below in a colored container
            Container(
              width: double.infinity,
              height: 40.0,
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue, // Background color for the text
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
