import 'package:flutter/material.dart';

class TimeUpScreen extends StatelessWidget {
  const TimeUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Time's Up!", style: TextStyle(fontSize: 24))),
    );
  }
}
