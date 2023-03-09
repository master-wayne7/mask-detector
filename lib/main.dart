import 'package:flutter/material.dart';
import 'package:mask_detection/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mask Detector',
      theme: ThemeData(
        primaryColor: Colors.teal,
        brightness: Brightness.dark,
      ),
      home: Home(),
    );
  }
}
