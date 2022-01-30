import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:pazada/configs/Universal_Variable.dart';
import 'package:pazada/dataHandler/appData.dart';
import 'package:pazada/main.dart';
import 'package:pazada/models/pazabuyMenus.dart';
import 'package:pazada/widgets/pazada_screen.dart';
import 'package:pazada/widgets/pazakay/pazakay.dart';
import 'package:pazada/widgets/shared/successDialog.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverInfo extends StatefulWidget {
  PazabuyMenus model;
  DriverInfo({this.model});
  static const String idScreen = "DriverInfo";
  @override
  State<DriverInfo> createState() => _DriverInfoState();
}

class _DriverInfoState extends State<DriverInfo> {
  String name = "Jose Gonzales";
  String phone = "09784563232";
  String trike = "Red - TMX155 - PZD22";


  @override
void initState() {
    // TODO: implement initState
    super.initState();
    showScan();


    if(Provider.of<AppData>(context, listen: false).pazadaDriver != null){

      rideStreamSubscription.pause();
      // setState(() {
      //   num = Provider.of<AppData>(context, listen: false).pazadaDriver.number;
      // });
      print("::::::::::::::::::::::::::::");


    }
    // Timer(Duration(seconds: 20), (){
    //   setState(() {
    //     cancelBtn =false;
    //
    //   });
    // });
  }
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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

                Text('Driver is On the Way.', style: TextStyle(fontSize: 22.0, fontFamily: 'Bolt-Bold'),),

                SizedBox(height: 25,),
                Divider(thickness: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Driver Name:', textAlign: TextAlign.center,style: TextStyle(fontFamily: 'bolt'),),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Phone:', textAlign: TextAlign.center,style: TextStyle(fontFamily: 'bolt'),),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Vehicle:", textAlign: TextAlign.center,style: TextStyle(fontFamily: 'bolt'),),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Amount to Pay:", textAlign: TextAlign.center,style: TextStyle(fontFamily: 'bolt'),),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(Provider.of<AppData>(context).pazadaDriver != null ? Provider.of<AppData>(context).pazadaDriver.username.toString() : name, textAlign: TextAlign.center,style: TextStyle(fontFamily: 'bolt'),),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(Provider.of<AppData>(context).pazadaDriver != null ? Provider.of<AppData>(context).pazadaDriver.number.toString() : phone, textAlign: TextAlign.center,style: TextStyle(fontFamily: 'bolt'),),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(Provider.of<AppData>(context).pazadaDriver != null ? Provider.of<AppData>(context).pazadaDriver.vehicle_details.toString() : trike, textAlign: TextAlign.center,style: TextStyle(fontFamily: 'bolt'),),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(price != null ? "Php "+price+ ".00" : "0", textAlign: TextAlign.center,style: TextStyle(fontFamily: 'bolt'),),
                        ),
                      ],

                    ),

                  ],
                ),

                SizedBox(height: 15,),
                Divider(thickness: 2,),
                // Row( NOTIFICATION BUTTONS DISABLED TEMPORARILY
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         GestureDetector(
                //           onTap: alertCall,
                //           child: Container(
                //
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(50),
                //               border: Border.all(color: Colors.greenAccent)
                //             ),
                //
                //             child: Padding(
                //               padding: EdgeInsets.all(10.0),
                //               child:  Icon(Icons.call, color: Colors.greenAccent, size: 20.0,
                //
                //                   ),
                //
                //
                //
                //             ),
                //           ),
                //         ),
                //         Text("Call Driver", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),),
                //       ],
                //     ),
                //     // Column(
                //     //   children: [
                //     //     Container(
                //     //        decoration: BoxDecoration(
                //     //        borderRadius: BorderRadius.circular(50),
                //     //         border: Border.all(color: Colors.amberAccent)
                //     //         ),
                //     //
                //     //
                //     //         child: Padding(
                //     //           padding: EdgeInsets.all(10.0),
                //     //           child: Icon(Icons.menu_open, color: Colors.amberAccent, size: 20.0,),
                //     //         ),
                //     //       ),
                //     //
                //     //     Text("Details", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),),
                //     //   ],
                //     // ),
                //     Column(
                //       children: [
                //         GestureDetector(
                //           onTap: (){
                //             if(cancelBtn == true){
                //               Navigator.pop(context);
                //               print("back");
                //             }else{
                //               rideStreamSubscription.cancel();
                //               showDialog(
                //                   context: context,
                //                   barrierDismissible: false,
                //                   builder: (BuildContext context) => SuccessDialog()
                //               );
                //               // String codeSanner = await BarcodeScanner.scan();    //barcode scnner
                //               // setState(() {
                //               //   qrCodeResult = codeSanner;
                //               // });
                //               // temp(); //NEED TO FIX THE SUCCESS DIALOG NULL BUG
                //             }
                //
                //
                //           },
                //           child: Container(
                //             decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.circular(50),
                //                 border: Border.all(color:cancelBtn == true? Colors.redAccent : Colors.lightBlueAccent)
                //             ),
                //             child: Padding(
                //               padding: EdgeInsets.all(10.0),
                //               child: Icon(cancelBtn == true?  Icons.cancel_outlined : Icons.flag_rounded,
                //                 color:cancelBtn == true? Colors.redAccent : Colors.lightBlueAccent, size: 20.0,),
                //             ),
                //           ),
                //         ),
                //         Text(cancelBtn == true? "Cancel" : "Arrived", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),),
                //       ],
                //     ),
                //     // Visibility(
                //     //   visible: scanBtn,
                //     //   child: Column(
                //     //     children: [
                //     //       GestureDetector(
                //     //         onTap: (){
                //     //           Navigator.pop(context);
                //     //           print("scan");
                //     //         },
                //     //         child: Container(
                //     //           decoration: BoxDecoration(
                //     //               borderRadius: BorderRadius.circular(50),
                //     //               border: Border.all(color: Colors.amberAccent)
                //     //           ),
                //     //           child: Padding(
                //     //             padding: EdgeInsets.all(10.0),
                //     //             child: Icon(Icons.qr_code_scanner_rounded, color: Colors.amberAccent, size: 20.0,),
                //     //           ),
                //     //         ),
                //     //       ),
                //     //       Text("Scan", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),),
                //     //     ],
                //     //   ),
                //     // ),
                //   ],
                // ),
                // NOTIFICATION BUTTONS DISABLED TEMPORARILY
                // widget.model.QRcode == null ?   Text(""):  QrImage(
                //   //plce where the QR Image will be shown
                //   data: widget.model.QRcode,
                // ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 53,
                        width: MediaQuery.of(context).size.width * .60,
                        child: RaisedButton(

                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          color: Colors.amber,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text('See Destination', style: TextStyle(
                                color: Colors.white,


                              ),

                              ),
                            ),
                          ),
                          onPressed: ()async{
                            rideStreamSubscription.cancel();
                            //storeUniqueID();
                            print("++++++++++++++++++++");
                            print(randomID);
                            print("++++++++++++++++++++");
                            pazada();
                            setState(() {
                              loadingRider = 280;
                              destinationContainer =0;
                              driver_name = Provider.of<AppData>(context, listen: false).pazadaDriver.username.toString();
                             driver_phone = Provider.of<AppData>(context, listen: false).pazadaDriver.number.toString();
                            });
                          },
                        ),
                      ),

                    ] ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  alertCall(){
    launch("tel://$numm");
  }
  void temp(){
    if(qrCodeResult != null){
      showSuccess();
    }
  }
  void showScan(){
    Timer(Duration(seconds: 20), (){
      setState(() {
        cancelBtn =false;

      });
    });
  }
  void showSuccess(){
    //if(qrCodeResult == keyy){

      print("======================================");
      print(keyy);
      print(qrCodeResult);
      print("======================================");
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog()
      );


    //}
  }
  void pazada (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> PazadaScreen()));
  }
  void storeUniqueID()async{
    DataSnapshot dataSnapshot = await usersRef.child("Ride_Request").child(rideRequestId).once();
    Map driverInformation = dataSnapshot.value;

    setState(() {
      randomID = driverInformation['uniqueID'];
    });
    print("======================================");
    print(randomID);
    print(driverID);
    print("======================================");
  }
}
