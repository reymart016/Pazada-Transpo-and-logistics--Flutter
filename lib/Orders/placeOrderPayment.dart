import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pazada/Config/config.dart';
import 'package:pazada/Store/storehome.dart';
import 'package:pazada/Counters/cartitemcounter.dart';
import 'package:pazada/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget
{
  final String addressId;
  final double totalAmount;

  PaymentPage({Key key, this.addressId, this.totalAmount,}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}




class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.pink, Colors.lightGreenAccent],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset("images/cash.png"),
              ),
              SizedBox(height: 10.0,),
              FlatButton(
                color: Colors.pinkAccent,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.deepOrange,
                onPressed: ()=> addOrderDetails(),
                child: Text("Place Order", style: TextStyle(fontSize: 30.0),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addOrderDetails()
  {
    writeOrderDetailsForUser({
      PazabuyApp.addressID: widget.addressId,
      PazabuyApp.totalAmount: widget.totalAmount,
      "orderBy": PazabuyApp.sharedPreferences.getString(PazabuyApp.userUID),
      PazabuyApp.productID: PazabuyApp.sharedPreferences.getStringList(PazabuyApp.userCartList),
      PazabuyApp.paymentDetails: "Cash on Delivery",
      PazabuyApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      PazabuyApp.isSuccess: true,
    });

    writeOrderDetailsForAdmin({
      PazabuyApp.addressID: widget.addressId,
      PazabuyApp.totalAmount: widget.totalAmount,
      "orderBy": PazabuyApp.sharedPreferences.getString(PazabuyApp.userUID),
      PazabuyApp.productID: PazabuyApp.sharedPreferences.getStringList(PazabuyApp.userCartList),
      PazabuyApp.paymentDetails: "Cash on Delivery",
      PazabuyApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      PazabuyApp.isSuccess: true,
    }).whenComplete(() => {
      emptyCartNow()
    });
  }

  emptyCartNow()
  {
    PazabuyApp.sharedPreferences.setStringList(PazabuyApp.userCartList, ["garbageValue"]);
    List tempList = PazabuyApp.sharedPreferences.getStringList(PazabuyApp.userCartList);

    Firestore.instance.collection("users")
        .document(PazabuyApp.sharedPreferences.getString(PazabuyApp.userUID))
        .updateData({
      PazabuyApp.userCartList: tempList,
    }).then((value)
    {
      PazabuyApp.sharedPreferences.setStringList(PazabuyApp.userCartList, tempList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });

    Fluttertoast.showToast(msg: "Congratulations, your Order has been placed successfully.");

    // Route route = MaterialPageRoute(builder: (c) => SplashScreen());
    // Navigator.pushReplacement(context, route);
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async
  {
    await PazabuyApp.firestore.collection(PazabuyApp.collectionUser)
        .document(PazabuyApp.sharedPreferences.getString(PazabuyApp.userUID))
        .collection(PazabuyApp.collectionOrders)
        .document(PazabuyApp.sharedPreferences.getString(PazabuyApp.userUID) + data['orderTime'])
        .setData(data);
  }

  Future writeOrderDetailsForAdmin(Map<String, dynamic> data) async
  {
    await PazabuyApp.firestore
        .collection(PazabuyApp.collectionOrders)
        .document(PazabuyApp.sharedPreferences.getString(PazabuyApp.userUID) + data['orderTime'])
        .setData(data);
  }
}
