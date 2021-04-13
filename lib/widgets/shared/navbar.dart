import 'package:flutter/material.dart';
import 'package:spincircle_bottom_bar/modals.dart';
import 'package:spincircle_bottom_bar/spincircle_bottom_bar.dart';

class BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SpinCircleBottomBar(
        bottomNavigationBar: SCBottomBarDetails(
          items: <SCBottomBarItem>[
            SCBottomBarItem(icon: Icons.add_shopping_cart, onPressed: (){}),
            SCBottomBarItem(icon: Icons.motorcycle_rounded, onPressed: (){}),
            SCBottomBarItem(icon: Icons.auto_awesome_mosaic, onPressed: (){}),
            SCBottomBarItem(icon: Icons.call_end, onPressed: (){}),
          ],
          circleItems: <SCItem>[
            SCItem(icon: Icon(Icons.add),onPressed: (){}),
            SCItem(icon: Icon(Icons.umbrella),onPressed: (){}),
            SCItem(icon: Icon(Icons.close),onPressed: (){})
          ]
        ),
      ),
    );
  }
}

