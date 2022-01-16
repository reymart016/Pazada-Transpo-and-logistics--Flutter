import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pazada/models/pazadaUserHistory.dart';


import 'package:provider/provider.dart';

class PazadaUserHistoryDetails extends StatefulWidget {
  PazadaUserHistoryModel models;
  PazadaUserHistoryDetails({this.models});
  @override
  State<PazadaUserHistoryDetails> createState() => _PazadaUserHistoryDetailsState();
}

class _PazadaUserHistoryDetailsState extends State<PazadaUserHistoryDetails> with SingleTickerProviderStateMixin{
  AnimationController lottieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //lottieController = AnimationController(duration: Duration(seconds: 3),vsync: this);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //lottieController.dispose();
  }
  @override

  Widget build(BuildContext context) {
    return Dialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding:  EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5,),

                Center(child: Text(widget.models.service_type, style: TextStyle(fontSize: 22.0, fontFamily: 'Bolt-Bold'),)),

                SizedBox(height: 5,),


                Text("Passenger name: "+
                    widget.models.driver_name,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "bolt"
                  ),//TextStyle
                ),
                SizedBox(height: 5,),
                Text("Phone number: "+
                    widget.models.driver_name,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "bolt"
                  ),//TextStyle
                ),
                SizedBox(height: 5,),
                Text("Pickup: "+
                    widget.models.pickup_address,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "bolt"
                  ),//TextStyle
                ),
                SizedBox(height: 5,),
                Text("Destination: "+
                    widget.models.destination_address,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "bolt"
                  ),//TextStyle
                ),
                SizedBox(height: 5,),
                Text("Amount: "+
                    widget.models.price,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "bolt"
                  ),//TextStyle
                ),
                SizedBox(height: 5,),
                Text("Date & Time: "+
                    widget.models.created_at.toDate().toString(),
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "bolt"
                  ),//TextStyle
                ),
                SizedBox(height: 5,),
                Text("Ride ID: "+
                    widget.models.pazadaHistoryID,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "bolt"
                  ),//TextStyle
                ),

                SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: RaisedButton(
                    onPressed: ()
                    {



                      Navigator.pop(context);

                    },
                    color: Theme.of(context).accentColor,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Ok", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),

                        ],
                      ),
                    ),
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );

  }


}
