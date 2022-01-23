import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:pazada/bottomBar/bottomAppBar.dart';
import 'package:pazada/configs/Universal_Variable.dart';
import 'package:pazada/dataHandler/appData.dart';
import 'package:pazada/widgets/idle_screen/idle_screen.dart';
import 'package:pazada/widgets/pazada_screen.dart';
import 'package:pazada/widgets/shared/completionQR.dart';
import 'package:pazada/widgets/shared/rateDriver.dart';
import 'package:pazada/configs/MapsConfig.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PazabuyDriverInfo extends StatefulWidget {
  @override
  State<PazabuyDriverInfo> createState() => _PazabuyDriverInfoState();
}

class _PazabuyDriverInfoState extends State<PazabuyDriverInfo> with SingleTickerProviderStateMixin{
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
              children: [
                SizedBox(height: 10,),

                Text('Scan the QR to Pay', style: TextStyle(fontSize: 22.0, fontFamily: 'Bolt-Bold'),),

                SizedBox(height: 5,),


                // Center(
                //   child: Lottie.asset('assets/lotties/success1.json', height:200),
                // ),
                QrImage(data: qrData),
                GestureDetector(
                  onTap: (){
                    LaunchApp.openApp(
                      androidPackageName: 'com.globe.gcash.android',
                      openStore: true,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.5,color: Colors.amber),
                      ),
                      child: Center(
                        child: Text("Open GCash", style: TextStyle(fontSize: 22.0, fontFamily: 'Bolt-Bold', color: Colors.blue),),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: RaisedButton(
                    onPressed: ()
                    {
                      // Map<String, dynamic> historyData = {
                      //   'ratings': starCounter.toStringAsFixed(2),
                      //   "created_at": DateTime.now(),
                      //   "passenger_name": usersCurrentInfo.name,
                      //   "passenger_phone": usersCurrentInfo.phone,
                      //   "pickup_address": pointA,
                      //   "destination_address": pointB,
                      //
                      // };
                      // FirebaseFirestore.instance.collection('PazadaSellers').doc(sellerUID).collection("History")
                      //     .doc(randomID).set(historyData).then((value) {
                      //   final productsRef = FirebaseFirestore.instance.collection("PazadaSellerHistory"); //SAVE AS MAIN COLLECTION
                      //   productsRef.doc(randomID).set({
                      //     'pazadaHistoryID': randomID,
                      //     'ratings': starCounter.toStringAsFixed(2),
                      //     "created_at": DateTime.now(),
                      //     "passenger_name": usersCurrentInfo.name,
                      //     "passenger_phone": usersCurrentInfo.phone,
                      //     "pickup_address": pointA,
                      //     "destination_address": pointB,
                      //     "review": review,
                      //     "price": price,
                      //     "driver_name": driver_name,
                      //     "driver_phone": driver_phone,
                      //
                      //   });
                      // });
                      updateRideHistory();

                      Navigator.pushNamedAndRemoveUntil(context, BottomBar.idScreen, (route) => false);
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) => CompletionQR()
                      );
                      setState(() {

                        loadingRider = 0;
                        destinationContainer =280;
                        driver_name = Provider.of<AppData>(context, listen: false).pazadaDriver.username.toString();
                        driver_phone = Provider.of<AppData>(context, listen: false).pazadaDriver.number.toString();
                        qrCodeResult = "";
                        numm = "";
                        cancelBtn = true;
                        scanBtn = false;
                      });
                    },
                    color: Theme.of(context).accentColor,
                    child: Padding(
                      padding: EdgeInsets.all(17.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Done", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),

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
  void updateRideHistory()async{
    DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("PazadaUsers").child(userId).child("history");
    setState(() {
      pickupLocationText = Provider.of<AppData>(context, listen: false).destinationLocation2!= null && mapbook == true
          ?  Provider.of<AppData>(context, listen: false).destinationLocation2.placename
          : Provider.of<AppData>(context, listen: false).pickUpLocation!= null && autoLoc == true
          ? Provider.of<AppData>(context, listen: false).pickUpLocation.placename : " ";
      destinationLocationText = Provider.of<AppData>(context, listen: false).destinationLocation!= null
          ? Provider.of<AppData>(context, listen: false).destinationLocation.placename
          : "";

    });
    Map rideHistory = {
      "rideID": rideRequestId,
      "created_at": DateTime.now().toString(),
      "driver_name": Provider.of<AppData>(context, listen: false).pazadaDriver.username,
      "pickup_location": pickupLocationText,
      "destination_location": destinationLocationText,
      "fare": fareText,
    };

    //usersRef.child(userId).child("history").child(rideRequestId).set(true);

    usersRef.update(
        {
          "rideID": rideRequestId,
          "created_at": DateTime.now().toString(),
          "driver_name": Provider.of<AppData>(context, listen: false).pazadaDriver.username,
          "pickup_location": pickupLocationText,
          "destination_location": destinationLocationText,
          "fare": fareText,
        }
    );
    usersRef.once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value != null){
        setState(() {
          rideHistoryy = dataSnapshot.value;
        });
        print("=================================");
        print(dataSnapshot.value.length);
        print("=================================");
      }
    });


  }
}
