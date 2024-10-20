import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartvolt1/user_side/total_bill_amount.dart';
import 'package:smartvolt1/user_side/view_electritions.dart';
import 'package:smartvolt1/Authentication/SignInPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAg_dUJIwZlfxHTHwnc1x3pxXG0_XHR-kE",
          appId: "1:686727571817:android:cda9999c533f93d48435f8",
          messagingSenderId: "686727571817",
          projectId: "smart-volt-b4aaa",
          storageBucket: "smart-volt-b4aaa.appspot.com"),
    );

    // Add appliances data to Firestore for room 104

  } catch (e) {
    print('Error initializing Firebase or Firebase Messaging: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HackMegdon',
      home: AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
