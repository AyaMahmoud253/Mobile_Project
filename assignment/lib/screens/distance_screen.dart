import 'package:assignment/widgets/buttomNavigationBar.dart';
import 'package:flutter/material.dart';

class CalculateDistancePage extends StatefulWidget {
  const CalculateDistancePage({super.key});

  @override
  State<CalculateDistancePage> createState() => _CalculateDistancePageState();
}

class _CalculateDistancePageState extends State<CalculateDistancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculate Distance',
        style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: MyNavigationBar(),
    );
  }
}