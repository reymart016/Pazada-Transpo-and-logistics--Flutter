import 'package:pazada/Config/config.dart';
import 'package:pazada/Store/cart.dart';
import 'package:pazada/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyAppBar extends StatelessWidget with PreferredSizeWidget
{
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      flexibleSpace: Container(
        decoration: new BoxDecoration(
          color: Colors.amber
        ),
      ),
      centerTitle: true,
      title: Text(
        "Pazabuy",
        style: TextStyle(fontSize: 25.0, color: Colors.white, fontFamily: "bolt-bold"),
      ),
      bottom: bottom,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.pink,),
              onPressed: ()
              {
                Route route = MaterialPageRoute(builder: (c) => CartPage());
                Navigator.pushReplacement(context, route);
              },
            ),
            Positioned(
              child: Stack(
                children: [
                  Icon(
                    Icons.brightness_1,
                    size: 20.0,
                    color: Colors.green,
                  ),
                  Positioned(
                    top: 3.0,
                    bottom: 4.0,
                    left: 4.0,
                    child: Consumer<CartItemCounter>(
                      builder: (context, counter, _)
                      {
                        return Text(
                          (PazabuyApp.sharedPreferences.getStringList(PazabuyApp.userCartList).length-1).toString(),
                          style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }


  Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}
