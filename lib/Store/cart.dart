import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pazada/Config/config.dart';
import 'package:pazada/Address/address.dart';
import 'package:pazada/widgets/customAppBar.dart';
import 'package:pazada/widgets/loadingWidget.dart';
import 'package:pazada/Modelss/item.dart';
import 'package:pazada/Counters/cartitemcounter.dart';
import 'package:pazada/Counters/totalMoney.dart';
import 'package:pazada/widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pazada/Store/storehome.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}



class _CartPageState extends State<CartPage>
{
  double totalAmount;

  @override
  void initState() {
    super.initState();

    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).display(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ()
        {
          if(PazabuyApp.sharedPreferences.getStringList(PazabuyApp.userCartList).length == 1)
          {
            Fluttertoast.showToast(msg: "your Cart is empty.");
          }
          else
          {
            Route route = MaterialPageRoute(builder: (c) => Address(totalAmount: totalAmount));
            Navigator.pushReplacement(context, route);
          }
        },
        label: Text("Check Out"),
        backgroundColor: Colors.pinkAccent,
        icon: Icon(Icons.navigate_next),
      ),
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(builder: (context, amountProvider, cartProvider, c)
            {
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: cartProvider.count == 0
                  ? Container()
                  : Text(
                    "Total Price: € ${amountProvider.totalAmount.toString()}",
                    style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500),
                  ),
                ),
              );
            },),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: PazabuyApp.firestore.collection("items")
                .where("shortInfo", whereIn: PazabuyApp.sharedPreferences.getStringList(PazabuyApp.userCartList)).snapshots(),
            builder: (context, snapshot)
            {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                  : snapshot.data.documents.length == 0
                  ? beginBuildingCart()
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (context, index)
                          {
                            ItemModel model = ItemModel.fromJson(snapshot.data.docs[index].data());

                            if(index == 0)
                            {
                              totalAmount = 0;
                              totalAmount = model.price + totalAmount;
                            }
                            else
                            {
                              totalAmount = model.price + totalAmount;
                            }

                            if(snapshot.data.documents.length - 1 == index)
                            {
                              WidgetsBinding.instance.addPostFrameCallback((t) {
                                Provider.of<TotalAmount>(context, listen: false).display(totalAmount);
                              });
                            }

                            return sourceInfo(model, context, removeCartFunction: () => removeItemFromUserCart(model.shortInfo));
                          },

                          childCount: snapshot.hasData ? snapshot.data.documents.length : 0,
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }

  beginBuildingCart()
  {
    return SliverToBoxAdapter(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Container(
          height: 100.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_emoticon, color: Colors.white,),
              Text("Cart is empty."),
              Text("Start adding items to your Cart."),
            ],
          ),
        ),
      ),
    );
  }

  removeItemFromUserCart(String shortInfoAsId)
  {
    List tempCartList = PazabuyApp.sharedPreferences.getStringList(PazabuyApp.userCartList);
    tempCartList.remove(shortInfoAsId);

    PazabuyApp.firestore.collection(PazabuyApp.collectionUser)
        .document(PazabuyApp.sharedPreferences.getString(PazabuyApp.userUID))
        .updateData({
      PazabuyApp.userCartList: tempCartList,
    }).then((v){
      Fluttertoast.showToast(msg: "Item Removed Successfully.");

      PazabuyApp.sharedPreferences.setStringList(PazabuyApp.userCartList, tempCartList);

      Provider.of<CartItemCounter>(context, listen: false).displayResult();

      totalAmount = 0;
    });
  }
}
