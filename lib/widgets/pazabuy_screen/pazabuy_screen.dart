import 'package:flutter/material.dart';

class Pazabuy extends StatefulWidget {
  @override
  _PazabuyState createState() => _PazabuyState();
}

class _PazabuyState extends State<Pazabuy> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Text("Pazabuy"),
        ),
      ),
    );
  }
}
