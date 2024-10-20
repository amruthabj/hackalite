import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EnergyPredictionPage extends StatefulWidget {
  @override
  _EnergyPredictionPageState createState() => _EnergyPredictionPageState();
}

class _EnergyPredictionPageState extends State<EnergyPredictionPage> {
  final _formKey = GlobalKey<FormState>();
  List<double> energyInput = [
    500, 480, 470, 460, 450, 445, 440, 435, 430, 420,
    410, 400, 395, 390, 380, 370, 360, 350, 340, 330,
    320, 310, 300, 290
  ];
  String predictionResult = 'Prediction: 275.34'; // Example prediction value
  double? predictionValue;

  @override
  void initState() {
    super.initState();
    predictionValue = 275.34; // Set example prediction value
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Energy Prediction'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Solar Usage Graph',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),

            SizedBox(height: 20),
            // Container for prediction value and chart
            Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5, spreadRadius: 2),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    predictionResult,
                    style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 300,
                    width: 500,
                    child: LineChart(
                      LineChartData(
                        backgroundColor: Colors.white,
                        gridData: FlGridData(
                          show: true,
                          horizontalInterval: 20, // Change this value to adjust spacing
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(), // Custom format for Y-axis labels
                                  style: TextStyle(color: Colors.blueAccent),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: const Color(0xff37434d), width: 1),
                        ),
                        minX: 0,
                        maxX: energyInput.length.toDouble() - 1,
                        minY: 0,
                        maxY: energyInput.reduce((a, b) => a > b ? a : b) + 100, // Adjust maxY
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              for (int i = 0; i < energyInput.length; i++)
                                FlSpot(i.toDouble(), energyInput[i]),
                              FlSpot(energyInput.length.toDouble() - 1, predictionValue!), // Prediction point
                            ],
                            isCurved: true,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
