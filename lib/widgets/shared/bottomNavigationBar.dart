import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:pazada/profile/profile_screen.dart';
import 'package:pazada/widgets/idle_screen/idle_screen.dart';
import 'package:pazada/widgets/pazada_screen.dart';

import 'package:pazada/widgets/shared/loading.dart';



class BottomNavBar extends StatefulWidget {

  static const String idScreen = "BottomNavScreen";

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  List activepage = [
    IdleScreen(),
    Profile(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: activepage[currentIndex],

      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        onItemSelected: (index){
          setState(() {

            currentIndex = index;
          });
        },
        items: [
          BottomNavyBarItem(icon: Icon(Icons.home), title: Text('Home'),activeColor: Colors.amber, inactiveColor: Colors.grey),
          BottomNavyBarItem(icon: Icon(Icons.person), title: Text('Profile'),activeColor: Colors.amber, inactiveColor: Colors.grey),
          // BottomNavyBarItem(icon: Icon(Icons.monetization_on_outlined), title: Text('Earnings'),activeColor: Colors.amber, inactiveColor: Colors.grey),
          // BottomNavyBarItem(icon: Icon(Icons.settings), title: Text('Settings'),activeColor: Colors.amber, inactiveColor: Colors.grey),

        ],
      ),
    );
  }
}
