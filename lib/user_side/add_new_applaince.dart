import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddAppliancePage extends StatefulWidget {
  final String roomId; // Room ID passed as a parameter

  AddAppliancePage({required this.roomId});

  @override
  _AddAppliancePageState createState() => _AddAppliancePageState();
}

class _AddAppliancePageState extends State<AddAppliancePage> {
  final _formKey = GlobalKey<FormState>();
  String? _applianceType; // To store the appliance type

  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _coolingCapacityController = TextEditingController();
  final TextEditingController _electricityConsumptionController = TextEditingController();
  final TextEditingController _compressorTypeController = TextEditingController();
  final TextEditingController _screenSizeController = TextEditingController();
  final TextEditingController _resolutionController = TextEditingController();
  final TextEditingController _powerConsumptionController = TextEditingController();
  final TextEditingController _washingCapacityController = TextEditingController();
  final TextEditingController _voltageController = TextEditingController(); // New controller for Voltage
  final TextEditingController _powerController = TextEditingController(); // New controller for Power

  Future<void> _addAppliance() async {
    if (_formKey.currentState!.validate()) {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      Map<String, dynamic> applianceData = {
        'userId': userId,
        'applianceType': _applianceType,
        'model': _modelController.text,
        'energyUsedMonth': 0,
        'energyUsedWeek': 0,
        'energyUsedDay': 0,
        'voltage': _voltageController.text,  // Add voltage field to appliance data
        'power': _powerController.text,      // Add power field to appliance data
      };

      if (_applianceType == 'Fridge') {
        applianceData['coolingCapacity'] = _coolingCapacityController.text;
        applianceData['electricityConsumption'] = _electricityConsumptionController.text;
        applianceData['compressorType'] = _compressorTypeController.text;
      } else if (_applianceType == 'Television') {
        applianceData['screenSize'] = _screenSizeController.text;
        applianceData['resolution'] = _resolutionController.text;
        applianceData['powerConsumption'] = _powerConsumptionController.text;
      } else if (_applianceType == 'Washing Machine') {
        applianceData['washingCapacity'] = _washingCapacityController.text;
        applianceData['electricityConsumption'] = _electricityConsumptionController.text;
      } else if (_applianceType == 'AC') {
        applianceData['coolingCapacity'] = _coolingCapacityController.text;
        applianceData['electricityConsumption'] = _electricityConsumptionController.text;
        applianceData['compressorType'] = _compressorTypeController.text;
      }

      // Add the appliance data to the specified room's Firestore document
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomId)
          .collection('appliances')
          .add(applianceData);

      // Clear the fields
      _modelController.clear();
      _coolingCapacityController.clear();
      _electricityConsumptionController.clear();
      _compressorTypeController.clear();
      _screenSizeController.clear();
      _resolutionController.clear();
      _powerConsumptionController.clear();
      _washingCapacityController.clear();
      _voltageController.clear(); // Clear voltage
      _powerController.clear();   // Clear power

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appliance added successfully')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Appliance'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Appliance Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              SizedBox(height: 20),

              // Appliance Type Selection
              Text(
                'Select Appliance Type:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildApplianceTypeCard('Fridge', 'images/fridge.png'),
                  _buildApplianceTypeCard('Television', 'images/television.png'),
                  _buildApplianceTypeCard('Washing Machine', 'images/wm.png'),
                  _buildApplianceTypeCard('AC', 'images/ac.png'),
                ],
              ),
              SizedBox(height: 20),

              // Common field for model
              TextFormField(
                controller: _modelController,
                decoration: InputDecoration(
                  labelText: 'Model',
                  filled: true,
                  fillColor: Colors.blue[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the model';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // New field for voltage
              TextFormField(
                controller: _voltageController,
                decoration: InputDecoration(
                  labelText: 'Voltage (V)',
                  filled: true,
                  fillColor: Colors.blue[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the voltage';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // New field for power
              TextFormField(
                controller: _powerController,
                decoration: InputDecoration(
                  labelText: 'Power (W)',
                  filled: true,
                  fillColor: Colors.blue[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the power';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Conditionally display fridge fields
              if (_applianceType == 'Fridge') ...[
                TextFormField(
                  controller: _coolingCapacityController,
                  decoration: InputDecoration(
                    labelText: 'Cooling Capacity',
                    filled: true,
                    fillColor: Colors.blue[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the cooling capacity';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _electricityConsumptionController,
                  decoration: InputDecoration(
                    labelText: 'Electricity Consumption',
                    filled: true,
                    fillColor: Colors.blue[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter electricity consumption';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _compressorTypeController,
                  decoration: InputDecoration(
                    labelText: 'Compressor Type',
                    filled: true,
                    fillColor: Colors.blue[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the compressor type';
                    }
                    return null;
                  },
                ),
              ],

              // Conditionally display television fields
              if (_applianceType == 'Television') ...[
                TextFormField(
                  controller: _screenSizeController,
                  decoration: InputDecoration(
                    labelText: 'Screen Size',
                    filled: true,
                    fillColor: Colors.blue[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the screen size';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _resolutionController,
                  decoration: InputDecoration(
                    labelText: 'Resolution',
                    filled: true,
                    fillColor: Colors.blue[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the resolution';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _powerConsumptionController,
                  decoration: InputDecoration(
                    labelText: 'Power Consumption',
                    filled: true,
                    fillColor: Colors.blue[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter power consumption';
                    }
                    return null;
                  },
                ),
              ],

              // Conditionally display washing machine fields
              if (_applianceType == 'Washing Machine') ...[
                TextFormField(
                  controller: _washingCapacityController,
                  decoration: InputDecoration(
                    labelText: 'Washing Capacity',
                    filled: true,
                    fillColor: Colors.blue[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter washing capacity';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _electricityConsumptionController,
                  decoration: InputDecoration(
                    labelText: 'Electricity Consumption',
                    filled: true,
                    fillColor: Colors.blue[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter electricity consumption';
                    }
                    return null;
                  },
                ),
              ],

              // Add Button
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addAppliance,
                child: Text('Add Appliance'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build appliance type card
  Widget _buildApplianceTypeCard(String applianceType, String imageAsset) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _applianceType = applianceType;
        });
      },
      child: Card(
        color: _applianceType == applianceType ? Colors.blueAccent : Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imageAsset, height: 100),
            SizedBox(height: 10),
            Text(
              applianceType,
              style: TextStyle(
                fontSize: 16,
                color: _applianceType == applianceType ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
