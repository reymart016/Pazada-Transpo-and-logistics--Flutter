import 'package:flutter/material.dart';

class Pazabuy extends StatefulWidget {
  @override
  _PazabuyState createState() => _PazabuyState();
}

class _PazabuyState extends State<Pazabuy> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Text("Pazabuy"),
            ],
          ),
        ),
      ),
    );
  }
}
