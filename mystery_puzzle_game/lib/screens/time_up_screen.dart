import 'package:flutter/material.dart';

class TimeUpScreen extends StatelessWidget {
  const TimeUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Time Up")),
      body: const Center(child: Text("Time is up!")),
    );
  }
}
