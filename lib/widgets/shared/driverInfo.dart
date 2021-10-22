import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:pazada/configs/Universal_Variable.dart';
import 'package:pazada/dataHandler/appData.dart';
import 'package:provider/provider.dart';

class DriverInfo extends StatefulWidget {
  static const String idScreen = "DriverInfo";
  @override
  State<DriverInfo> createState() => _DriverInfoState();
}

class _DriverInfoState extends State<DriverInfo> {
  @override
void initState() {
    // TODO: implement initState
    super.initState();
    if(Provider.of<AppData>(context, listen: false).pazadaDriver != null){
      rideStreamSubscription.pause();
      print("::::::::::::::::::::::::::::");
    }
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
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(Provider.of<AppData>(context).pazadaDriver != null ? Provider.of<AppData>(context).pazadaDriver.username : 'Username', textAlign: TextAlign.center,style: TextStyle(fontFamily: 'bolt'),),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(Provider.of<AppData>(context).pazadaDriver != null ? Provider.of<AppData>(context).pazadaDriver.number : 'Vehicle', textAlign: TextAlign.center,style: TextStyle(fontFamily: 'bolt'),),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(Provider.of<AppData>(context).pazadaDriver != null ? Provider.of<AppData>(context).pazadaDriver.vehicle_details : "0016", textAlign: TextAlign.center,style: TextStyle(fontFamily: 'bolt'),),
                ),

                SizedBox(height: 15,),
                Divider(thickness: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.greenAccent)
                          ),

                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child:  Icon(Icons.call, color: Colors.greenAccent, size: 20.0,

                                ),



                          ),
                        ),
                        Text("Call Driver", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                           decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.amberAccent)
                            ),


                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(Icons.menu_open, color: Colors.amberAccent, size: 20.0,),
                            ),
                          ),

                        Text("Details", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                            print("back");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: Colors.redAccent)
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 20.0,),
                            ),
                          ),
                        ),
                        Text("Cancel", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),),
                      ],
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
