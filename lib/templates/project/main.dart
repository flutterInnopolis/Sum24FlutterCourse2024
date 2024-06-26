// lib/main.dart
import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantNanny',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home:null,
    );
  }
}
