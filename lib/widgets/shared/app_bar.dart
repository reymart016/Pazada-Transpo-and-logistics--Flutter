import 'package:flutter/material.dart';
import 'package:pazada/assistants/pazabuy/cart_item_counter.dart';
import 'package:pazada/main.dart';
import 'package:pazada/models/pazabuyProduct.dart';
import 'package:pazada/widgets/pazabuy_screen/cart_screen.dart';
//import 'package:pazada/widgets/pazabuy_screen/cart_screen.dart';
import 'package:provider/provider.dart';


class MyAppBar extends StatefulWidget with PreferredSizeWidget
{
  PazabuyProducts model;
  final PreferredSizeWidget bottom;
  final String sellerUID;

  MyAppBar({this.bottom, this.sellerUID});

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => bottom==null?Size(56, AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}

class _MyAppBarState extends State<MyAppBar>
{
  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            color: Colors.amber
        ),
      ),
      leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.keyboard_arrow_left, color: Colors.white,)
      ),
      title: const Text(
        "Pazabuy",
        style: TextStyle(fontSize: 25, fontFamily: "bolt-bold", color: Colors.white),
      ),
      centerTitle: true,
      automaticallyImplyLeading: true,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white,),
              onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (c)=> CartScreen(sellerUID: widget.sellerUID, model: widget.model,)));
              },
            ),
            Positioned(
              top: 3,
              left: 21,
              child: Stack(
                children: [
                  Container(


                    width: 25.0,
                    height: 17.5,

                    decoration: BoxDecoration(
                        color: Colors.amberAccent,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 9,
                    child: Center(
                      child: Consumer<CartItemCounter>(
                        builder: (context, counter, c)
                        {
                          return Text(
                            counter.count.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'bolt-bold'),
                          );
                        },
                      ),
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
}
