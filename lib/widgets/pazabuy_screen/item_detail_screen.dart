import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pazada/assistants/pazabuy/cart_item_counter.dart';
import 'package:pazada/configs/Universal_Variable.dart';
import 'package:pazada/dataHandler/appData.dart';
import 'package:pazada/models/PazabuyOrder.dart';

import 'package:pazada/models/pazabuyProduct.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:pazada/assistants/assistantMethod.dart';
import 'package:pazada/widgets/pazabuy_screen/pazabuy_query.dart';
import 'package:pazada/widgets/shared/app_bar.dart';
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
      appBar: MyAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 15,),
         Center(child:  Container(height: 300,
             child: Image.network(widget.model.thumbnailUrl.toString())),),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Container(width: 300,height: 50,
                child: NumberInputPrefabbed.roundedEdgeButtons(
                  incIcon: Icons.add,
                  decIcon: Icons.minimize_outlined,
                  enableMinMaxClamping: false,
                  controller: counterTextEditingController,
                  incDecBgColor: Colors.amber,
                  min: 1,
                  max: 9,
                  initialValue: 1,
                  buttonArrangement: ButtonArrangement.incRightDecLeft,

                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height/6,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              // boxShadow:[
              //   BoxShadow(
              //     color: Colors.black,
              //     blurRadius: 16,
              //     spreadRadius: .5,
              //     offset: Offset(.0, .1),
              //   )
              // ]
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [


                Column( crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),

                      child: Text(
                       "Product name: ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),//text
                    ),//padding

                    Padding(
                      padding: const EdgeInsets.all(8.0),

                      child: Text(
                        "Description: ",
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                      ),//text
                    ),//padding

                    Padding(
                      padding: const EdgeInsets.all(8.0),

                      child: Text(
                        "Price: " ,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),//text
                    ),//padding

                    SizedBox(height: 10,),

                  ],
                ),
              Column( crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),

                    child: Text(
                      widget.model.productName.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),//text
                  ),//padding

                  Padding(
                    padding: const EdgeInsets.all(8.0),

                    child: Text(
                      widget.model.productDetails.toString(),
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                    ),//text
                  ),//padding

                  Padding(
                    padding: const EdgeInsets.all(8.0),

                    child: Text(
                      "Php " + widget.model.price.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),//text
                  ),//padding

                  SizedBox(height: 10,),

                ],
              ),

              Column(
                children: [

                ],
              )
            ],),
          ),
          SizedBox(height: 15,),

         SizedBox(height: 50,),

          Center(
              child: InkWell(
                onTap: ()
                {
                  savePazabuyBooking();
                  quantity = int.parse(counterTextEditingController.text);
                  //services3();
                  readDatabase();
                  int itemCounter = int.parse(counterTextEditingController.text);

                  List<String> separateItemsIDsList = separateItemIDs();
                  //
                  print("napindot");
                  separateItemsIDsList.contains(widget.model.productID)
                  ? Fluttertoast.showToast(msg: "${widget.model.productName.toString()} is already in the cart.")
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
                      "Add to Cart",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),//text
                  ),//Center
                ),//container
              )//inkwell
          ),

          //Center
        ],
      ),//Column
    );
  }
  void savePazabuyBooking(){
    PazabuyOrder pazabuyOrder = new PazabuyOrder();
    pazabuyOrder.sellerName = widget.model.sellerName;
    pazabuyOrder.itemValue = widget.model.price.toString();
    pazabuyOrder.thumbnailUrl = widget.model.thumbnailUrl;
    pazabuyOrder.stats = false;
    Provider.of<AppData>(context, listen: false).updatePazabuyOrder(pazabuyOrder);



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
