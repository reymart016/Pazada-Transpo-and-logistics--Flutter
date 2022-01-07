import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pazada/assistants/pazabuy/cart_item_counter.dart';

import 'package:pazada/models/pazabuyProduct.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:pazada/assistants/assistantMethod.dart';
import 'package:pazada/widgets/pazabuy_screen/pazabuy_query.dart';
import 'package:pazada/widgets/shared/under_construction.dart';
import 'package:provider/provider.dart';

class ItemDetailScreen extends StatefulWidget {
  PazabuyProducts model;
  ItemDetailScreen({this.model});

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  QuerySnapshot PazadaUsers;
  TextEditingController counterTextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          "Pazabuy",
          style: TextStyle(fontSize: 25.0, color: Colors.white, fontFamily: "bolt-bold"),
        ),
        centerTitle: true,
        actions: [
          // Stack(
          //   children: [
          //     IconButton(
          //       icon: Icon(Icons.shopping_cart, color: Colors.white,),
          //       onPressed: ()
          //       {
          //         Route route = MaterialPageRoute(builder: (c) => UnderConstruction());
          //        Navigator.pushReplacement(context, route);
          //       },
          //     ),
          //     Positioned(
          //       child: Stack(
          //         children: [
          //           Icon(
          //             Icons.circle,
          //             size: 20.0,
          //             color: Colors.green,
          //           ),
          //           Positioned(
          //             top: 3.0,
          //             bottom: 4.0,
          //             left: 5.0,
          //             child:
          //
          //             Center(
          //               child:  Consumer<CartItemCounter>(
          //                 builder: (context, counter, c){
          //                   return Text(counter.count.toString(),
          //                   style: TextStyle(fontFamily: 'bolt', fontSize: 12, color: Colors.white),
          //                   );
          //                 },
          //               ),
          //             )
          //
          //
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(widget.model.thumbnailUrl.toString()),
          SizedBox(height: 10,),
          NumberInputPrefabbed.roundedButtons(
            controller: counterTextEditingController,
            incDecBgColor: Colors.amber,
            min: 1,
            max: 9,
            initialValue: 1,
            buttonArrangement: ButtonArrangement.incRightDecLeft,

          ),

          Padding(
            padding: const EdgeInsets.all(8.0),

            child: Text(
              widget.model.productName.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),//text
          ),//padding

          Padding(
            padding: const EdgeInsets.all(8.0),

            child: Text(
              widget.model.productDetails.toString(),
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            ),//text
          ),//padding

          Padding(
            padding: const EdgeInsets.all(8.0),

            child: Text(
              "Php " + widget.model.price,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),//text
          ),//padding

          SizedBox(height: 10,),

          Center(
              child: InkWell(
                onTap: ()
                {
                  services3();
                  readDatabase();
                  int itemCounter = int.parse(counterTextEditingController.text);

                  List<String> separateItemsIDsList = separateItemIDs();
                  //
                  print("napindot");
                  separateItemsIDsList.contains(widget.model.productID)
                  ? Fluttertoast.showToast(msg: "Item is already in the cart.")
                  :
                  addItemToCart(widget.model.productID, context, itemCounter);

                },
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.cyan,
                        Colors.amber,
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),//LinearGradient
                  ),//BoxDecoration
                  width: MediaQuery.of(context).size.width - 13,
                  height: 50,
                  child: Center(
                    child: Text(
                      "Buy Now",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),//text
                  ),//Center
                ),//container
              )//inkwell
          ), //Center
        ],
      ),//Column
    );
  }
  void services3 (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> PazabuyQuery(model: widget.model,)));
  }
  void readDatabase(){
    FirebaseFirestore.instance.collection("PazadaUsers")
        .where("userCart")
        .get().then((results)
    {
      print("INVOKED!!!!!!!!!!");
      setState(() {
        //UserKart = results.l;
      });
      print(PazadaUsers.docs[1].get("userCart"));
    });
  }
}
