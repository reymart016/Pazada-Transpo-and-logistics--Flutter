import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pazada/assistants/assistantMethod.dart';
import 'package:pazada/assistants/pazabuy/cart_item_counter.dart';
import 'package:pazada/assistants/total_amount.dart';
import 'package:pazada/configs/Universal_Variable.dart';
import 'package:pazada/dataHandler/appData.dart';
import 'package:pazada/models/PazabuyOrder.dart';
import 'package:pazada/models/pazabuyProduct.dart';
import 'package:pazada/widgets/pazabuy_screen/item_detail_screen.dart';
import 'package:pazada/widgets/pazabuy_screen/pazabuy_query.dart';
import 'package:pazada/widgets/pazabuy_screen/pazabuy_screen.dart';
import 'package:pazada/widgets/pazabuy_screen/widgets/cart_item_design.dart';
import 'package:pazada/widgets/shared/app_bar.dart';
import 'package:pazada/widgets/shared/loading.dart';
import 'package:pazada/widgets/shared/text_widget_header.dart';

import 'package:provider/provider.dart';


class CartScreen extends StatefulWidget
{
  PazabuyProducts model;
  final String sellerUID;

  CartScreen({this.model, this.sellerUID});

  @override
  _CartScreenState createState() => _CartScreenState();
}




class _CartScreenState extends State<CartScreen>
{
  List<int> separateItemQuantityList;
  num totalAmount = 0;

  @override
  void initState() {
    super.initState();
    double temp = 49;
    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(0);

    separateItemQuantityList = separateItemQuantities();


    print("++++++++++++++++++");
    print(total);
    print("++++++++++++++++++");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              color: Colors.amber
          ),
        ),
        leading: SizedBox(height: 0,),
        // leading: GestureDetector(
        //     onTap: (){
        //       Navigator.push(context, MaterialPageRoute(builder: (c)=>  PazabuyScreen()));
        //     },
        //     child: Icon(Icons.keyboard_arrow_left, color: Colors.white,)
        // ),
        title: const Text(
          "Pazabuy",
          style: TextStyle(fontSize: 25, fontFamily: "bolt-bold", color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        // actions: [
        //   Stack(
        //     children: [
        //       IconButton(
        //         icon: const Icon(Icons.shopping_cart, color: Colors.white,),
        //         onPressed: ()
        //         {
        //           Navigator.push(context, MaterialPageRoute(builder: (c)=> CartScreen(sellerUID: widget.sellerUID)));
        //         },
        //       ),
        //       Positioned(
        //         child: Stack(
        //           children: [
        //             Container(
        //
        //
        //               width: 25.0,
        //               height: 18,
        //
        //               decoration: BoxDecoration(
        //                   color: Colors.green,
        //                   borderRadius: BorderRadius.circular(10)
        //               ),
        //             ),
        //             Positioned(
        //               top: 3,
        //               right: 9,
        //               child: Center(
        //                 child: Consumer<CartItemCounter>(
        //                   builder: (context, counter, c)
        //                   {
        //                     return Text(
        //                       counter.count.toString(),
        //                       style: TextStyle(color: Colors.white, fontSize: 12),
        //                     );
        //                   },
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ],
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton.extended(
              label: const Text("Clear Cart", style: TextStyle(fontSize: 16, color: Colors.white,
                fontFamily: "bolt",),),
              backgroundColor: Colors.red,
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: ()
              {
                clearCartNow(context);

                //Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
                Navigator.push(context, MaterialPageRoute(builder: (context)=> PazabuyScreen()));
                Fluttertoast.showToast(msg: "Cart has been cleared.");
              },
            ),
            GestureDetector(
              onTap: (){
                services3();
                savePazabuyBooking();
              },
              child: Container(
                child: Center(
                  child: Text("Check Out", style: TextStyle(fontSize: 16,color: Colors.white,
                    fontFamily: "bolt",),),
                ),



                width: 140.0,
                height: 50,

                decoration: BoxDecoration(

                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),

          ],
        )
      ],
      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //   children: [
      //     const SizedBox(width: 5,),
      //     Align(
      //       alignment: Alignment.bottomLeft,
      //       child: FloatingActionButton.extended(
      //         label: const Text("Clear Cart", style: TextStyle(fontSize: 16, color: Colors.white,
      //           fontFamily: "bolt",),),
      //         backgroundColor: Colors.amber,
      //         icon: const Icon(Icons.delete, color: Colors.white),
      //         onPressed: ()
      //         {
      //           clearCartNow(context);
      //
      //           //Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
      //           Navigator.push(context, MaterialPageRoute(builder: (context)=> PazabuyScreen()));
      //           Fluttertoast.showToast(msg: "Cart has been cleared.");
      //         },
      //       ),
      //     ),
      //     Align(
      //       alignment: Alignment.bottomLeft,
      //       child: FloatingActionButton.extended(
      //         label: const Text("Check Out", style: TextStyle(fontSize: 16,color: Colors.white,
      //           fontFamily: "bolt",),),
      //         backgroundColor: Colors.amber,
      //         icon: const Icon(Icons.navigate_next, color: Colors.white),
      //         onPressed: ()
      //         {
      //           services3();
      //           // Navigator.push(
      //           //     context,
      //           //     MaterialPageRoute(
      //           //         builder: (c)=> AddressScreen(
      //           //           totalAmount: totalAmount.toDouble(),
      //           //           sellerUID: widget.sellerUID,
      //           //         ),
      //           //     ),
      //           // );
      //         },
      //       ),
      //     ),
      //   ],
      // ),
      body: CustomScrollView(
        slivers: [

          //overall total amount
          SliverPersistentHeader(
              pinned: true,
              delegate: TextWidgetHeader(title: "My Cart List")
          ),

          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(builder: (context, amountProvider, cartProvider, c)
            {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: cartProvider.count == 0
                      ? Container()
                      : Text(
                    "Total Price: " + amountProvider.tAmount.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight:  FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
          ),


          //display cart items with quantity number
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("PazadaProducts")
                .where("productID", whereIn: separateItemIDs())
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot)
            {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(child: Center(child: Loading(),),)
                  : snapshot.data.docs.length == 0
                  ? //startBuildingCart()
              Container()
                  : SliverList(
                delegate: SliverChildBuilderDelegate((context, index)
                {
                  PazabuyProducts model = PazabuyProducts.fromJson(
                    snapshot.data.docs[index].data() as Map<String, dynamic>,
                  );

                  if(index == 0)
                  {
                    totalAmount = 0;
                    totalAmount = totalAmount + (model.price * separateItemQuantityList[index]);
                  }
                  else
                  {
                    totalAmount = totalAmount + (model.price * separateItemQuantityList[index]);
                  }

                  if(snapshot.data.docs.length - 1 == index)
                  {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp)
                    {
                      Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(totalAmount.toDouble());
                    });
                  }

                  return CartItemDesign(
                    model: model,
                    context: context,
                    quanNumber: separateItemQuantityList[index],
                  );
                },
                  childCount: snapshot.hasData ? snapshot.data.docs.length : 0,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  void savePazabuyBooking(){
    double temp = 49;
    setState(() {
      total = totalAmount.toDouble() + temp;
    });


    rideRequestRef = FirebaseDatabase.instance.reference().child("Ride_Request").push();
    Map pazShipBooking = {
      "seller_name":Provider.of<AppData>(context, listen: false).pazabuyOrder.sellerName,

      "PazShip": false,
      "Pazabuy": true,
      "fares": 49,

    };
    PazabuyOrder pazabuyOrder = new PazabuyOrder();
    rideRequestRef.set(pazShipBooking);
    setState(() {
      rideKey = rideRequestRef.key;
      pazabuyOrder.key =rideKey;
    });
    print(rideKey);
    Provider.of<AppData>(context, listen: false).updatePazabuyOrder(pazabuyOrder);


  }
  void services3(){
    setState(() {
      total = totalAmount.toDouble() + tempPrice;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context)=> PazabuyQuery(model: widget.model,)));
  }
}
