import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pazada/assistants/assistantMethod.dart';
import 'package:pazada/assistants/pazabuy/cart_item_counter.dart';
import 'package:pazada/assistants/total_amount.dart';
import 'package:pazada/models/pazabuyProduct.dart';
import 'package:pazada/widgets/pazabuy_screen/pazabuy_query.dart';
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

    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(0);

    separateItemQuantityList = separateItemQuantities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(width: 10,),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              label: const Text("Clear Cart", style: TextStyle(fontSize: 16),),
              backgroundColor: Colors.cyan,
              icon: const Icon(Icons.clear_all),
              onPressed: ()
              {
                clearCartNow(context);

                //Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));

                Fluttertoast.showToast(msg: "Cart has been cleared.");
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              label: const Text("Check Out", style: TextStyle(fontSize: 16),),
              backgroundColor: Colors.cyan,
              icon: const Icon(Icons.navigate_next),
              onPressed: ()
              {
                services3();
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (c)=> AddressScreen(
                //           totalAmount: totalAmount.toDouble(),
                //           sellerUID: widget.sellerUID,
                //         ),
                //     ),
                // );
              },
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          
          //overall total amount
          SliverPersistentHeader(
              pinned: true,
              delegate: TextWidgetHeader(title: "My Cart List")
          ),

          // SliverToBoxAdapter(
          //   child: Consumer2<TotalAmount, CartItemCounter>(builder: (context, amountProvider, cartProvider, c)
          //   {
          //     return Padding(
          //       padding: const EdgeInsets.all(8),
          //       child: Center(
          //         child: cartProvider.count == 0
          //             ? Container()
          //             : Text(
          //                 "Total Price: " + amountProvider.tAmount.toString(),
          //                   style: const TextStyle(
          //                     color: Colors.black,
          //                     fontSize: 18,
          //                     fontWeight:  FontWeight.w500,
          //                   ),
          //               ),
          //       ),
          //     );
          //   }),
          // ),
          
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

                      // if(index == 0)
                      // {
                      //   totalAmount = 0;
                      //   totalAmount = totalAmount + (model.price * separateItemQuantityList[index]);
                      // }
                      // else
                      // {
                      //   totalAmount = totalAmount + (model.price * separateItemQuantityList[index]);
                      // }
                      //
                      // if(snapshot.data.docs.length - 1 == index)
                      // {
                      //   WidgetsBinding.instance.addPostFrameCallback((timeStamp)
                      //   {
                      //     Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(totalAmount.toDouble());
                      //   });
                      // }

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
  void services3(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> PazabuyQuery(model: widget.model,)));
  }
}
