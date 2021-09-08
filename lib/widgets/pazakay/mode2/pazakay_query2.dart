import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pazada/dataHandler/appData.dart';
import 'package:pazada/widgets/pazada_screen.dart';
import 'package:pazada/widgets/pazakay/mode2/pazada_screen2.dart';
import 'package:pazada/widgets/pazakay/pazakay_payment.dart';
import 'package:pazada/widgets/shared/divider.dart';
import 'package:provider/provider.dart';
import 'package:pazada/assistants/assistantMethod.dart';
import 'package:pazada/dataHandler/appData.dart';
import 'package:pazada/models/directionDetails.dart';
import 'package:provider/provider.dart';
import 'package:pazada/main.dart';
import 'package:pazada/configs/MapsConfig.dart';


class PazakayQuery2 extends StatefulWidget {
  @override
  _PazakayQuery2State createState() => _PazakayQuery2State();
}

class _PazakayQuery2State extends State<PazakayQuery2> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();
  String valueChoose,vehicleChoose;
  List listItem = ["PazPaz", "Willing to Wait"];
  List vehicleItem = ["Catablan - Pabor", "Habal","Padyak"];
  String CurrentPosition, mapLocation;
  Position currentPosition,desPosition;
  String manualBook='';
  bool mapbook =false;
  bool autoLoc = false;
  String manualBooking = "";
  TextEditingController mapBooking = TextEditingController();

  List<LatLng> pLinesCoordinates = [];
  Set<Polyline> polylineSet = {};
  Set<Marker> markersSet = {};
  Set<Circle> circleSet = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
            children: [Container(
              child: Column(
                children: [
                  Container(
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Carousel(
                        dotSize: 2,
                        dotSpacing: 15,
                        dotColor: Colors.white,
                        indicatorBgPadding: 5,
                        dotBgColor: Colors.transparent,
                        images: [
                          Image.asset("images/jpegs/1.jpg", fit: BoxFit.cover,),
                          Image.asset("images/jpegs/2.jpg", fit: BoxFit.cover),
                          Image.asset("images/jpegs/3.jpg", fit: BoxFit.cover),
                        ],
                      ),
                    ),
                  ),

                  Center(
                    child: Container(
                      height: 240,
                      alignment: Alignment.center,

                      width: MediaQuery.of(context).size.width * .96,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(
                              color: Colors.grey,
                              blurRadius: 20,
                              spreadRadius: .5,
                              offset: Offset(1,5)
                          )]
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 15,),
                          Stack(
                            children: [

                              Center(
                                child: Text("Set Drop-Off", style:TextStyle(fontSize: 18,fontFamily: 'bolt-bold')),
                              )
                            ],
                          ),
                          SizedBox(height: 16,),
                          DividerWidget(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal:14.0),
                            child: Row(
                              children:[
                                Image.asset("images/pazada-logo.png", height: 16, width: 16,),
                                SizedBox(width: 5,),
                                Expanded(

                                  child: Container(


                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                                      child: GestureDetector(
                                        onTap: (){
                                          pazakay2();
                                          setState(() {
                                            mapbook = true;
                                            autoLoc = false;
                                          });
                                        },
                                        child: Text(mapbook == true && Provider.of<AppData>(context).destinationLocation2!= null
                                            ?  Provider.of<AppData>(context).destinationLocation2.placename
                                            : autoLoc ==true && Provider.of<AppData>(context).pickUpLocation!= null
                                            ? Provider.of<AppData>(context).pickUpLocation.placename
                                            : "Add Home", style: TextStyle(fontSize: 15, fontFamily: "bolt"),maxLines: 2,textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        mapbook = false;
                                        autoLoc = true;
                                      });
                                      saveManualMapLocation();

                                      print('PRESS');
                                      print(manualBooking);
                                    },
                                    child: Icon(Icons.my_location_outlined)
                                ),
                              ],
                            ),
                          ),
                          DividerWidget(),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal:14.0),
                            child: Row(
                              children: [
                                Image.asset("images/pazada-logo.png", height: 16, width: 16,),
                                SizedBox(width: 5,),
                                Expanded(
                                  child: Container(

                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal:30, vertical: 25),
                                      child: Text(Provider.of<AppData>(context).destinationLocation!= null
                                          ? Provider.of<AppData>(context).destinationLocation.placename
                                          : "Destination", style: TextStyle(fontSize: 15, fontFamily: "bolt"),maxLines: 2,textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),),
                                GestureDetector(
                                    onTap: pazakay,
                                    child: Icon(Icons.my_location_outlined)
                                ),
                              ],
                            ),
                          ),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //
                          //     Container(
                          //
                          //       width: MediaQuery.of(context).size.width * .38,
                          //       decoration: BoxDecoration(
                          //         color: Colors.grey[200],
                          //         borderRadius: BorderRadius.circular(5),
                          //
                          //       ),
                          //       child: Padding(
                          //         padding: const EdgeInsets.symmetric(horizontal:5,),
                          //         child: DropdownButton(
                          //           underline: SizedBox(),
                          //           isExpanded: true,
                          //           icon: Icon(Icons.arrow_drop_down_circle_outlined),
                          //           hint: Text("Select Service", style: TextStyle(fontSize: 15, fontFamily: "bolt"),textAlign: TextAlign.center, ),
                          //           value: valueChoose,
                          //           onChanged:(newValue){
                          //             setState(() {
                          //               valueChoose = newValue;
                          //             });
                          //           },
                          //           items: listItem.map((valueItem){
                          //             return DropdownMenuItem(
                          //               value: valueItem,
                          //               child: Text(valueItem,style: TextStyle(fontSize: 15, fontFamily: "bolt"),textAlign: TextAlign.center,),
                          //             );
                          //           }).toList(),
                          //         ),
                          //       ),
                          //     ),
                          //     SizedBox(width: 18,),
                          //     Container(
                          //       width: MediaQuery.of(context).size.width * .38,
                          //       decoration: BoxDecoration(
                          //         color: Colors.grey[200],
                          //         borderRadius: BorderRadius.circular(5),
                          //
                          //       ),
                          //       child: Padding(
                          //         padding: const EdgeInsets.symmetric(horizontal:5,),
                          //         child: DropdownButton(
                          //           underline: SizedBox(),
                          //           isExpanded: true,
                          //           icon: Icon(Icons.arrow_drop_down_circle_outlined),
                          //           hint: Text("Select Toda",style: TextStyle(fontSize: 15, fontFamily: "bolt"),textAlign: TextAlign.center, ),
                          //           value: vehicleChoose,
                          //           onChanged:(vehicleValue){
                          //             setState(() {
                          //               vehicleChoose = vehicleValue;
                          //             });
                          //           },
                          //           items: vehicleItem.map((vehicleItem){
                          //             return DropdownMenuItem(
                          //               value: vehicleItem,
                          //               child: Text(vehicleItem,style: TextStyle(fontSize: 15, fontFamily: "bolt"),textAlign: TextAlign.center,),
                          //             );
                          //           }).toList(),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            ),
              Spacer(flex: 7,),


              Expanded(
                flex: 2,
                child: Column(
                  children: [

                    FlatButton(onPressed: ()async{
                      await getPlaceDirection();

                      //Navigator.pop(context, "obtainDirection");
                      pazakayPayment();
                    },
                      color: Colors.amber,
                      minWidth:MediaQuery.of(context).size.width * .96 ,
                      height: 60,
                      child: Text("Request", style: TextStyle(fontFamily: "bolt", fontSize:18, color: Colors.white),textAlign: TextAlign.center, ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),

                      ),
                    )

                  ],
                ),
              ),
            ]),
      ),

    );
  }
  void pazakay (){

    Navigator.push(context, MaterialPageRoute(builder: (context)=> PazadaScreen()));
  }
  Future<void> pazakay2 ()async{


    Navigator.push(context, MaterialPageRoute(builder: (context)=> PazadaScreen2()));
  }
  void pazakayPayment (){

    Navigator.push(context, MaterialPageRoute(builder: (context)=> PazakayPayment()));
  }
  void getPosition (){
    setState(() {
      CurrentPosition = Provider.of<AppData>(context).pickUpLocation.placename;

    });


  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<void> saveManualMapLocation()async{
    String userId = firebaseUser.uid;
    var finalPos = Provider.of<AppData>(context, listen: false).destinationLocation;
    Map manualMapBooking = {
      "map_location": finalPos

    };
    usersRef.child(userId).child("manual_booking").set(manualMapBooking);

  }

  Future <void> getPlaceDirection()async{
    var initialPos = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).destinationLocation;
    var pickupLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var destinationLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    //showDialog(context: context, builder: (BuildContext context)=> ProgressDialog(message: "Please wait...."));

    var details = await AssistantMethod.obtainPlaceDirectionDetails(pickupLatLng, destinationLatLng);
    setState(() {
      tripDirectionDetails = details;
    });
    //Navigator.pop(context);

    print("This is encoded Points::");
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List <PointLatLng> decodedPolylinePointsResult = polylinePoints.decodePolyline(details.encodedPoints);
    pLinesCoordinates.clear();
    if(decodedPolylinePointsResult.isNotEmpty){
      decodedPolylinePointsResult.forEach((PointLatLng pointLatLng) {
        pLinesCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: Colors.amber,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLinesCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polylineSet.add(polyline);
    });
    // LatLngBounds latLngBounds;
    // if(pickupLatLng.latitude > destinationLatLng.latitude && pickupLatLng.longitude > destinationLatLng.longitude){
    //   latLngBounds = LatLngBounds(southwest: destinationLatLng, northeast: pickupLatLng);
    //
    // }
    // else if(pickupLatLng.longitude > destinationLatLng.longitude){
    //   latLngBounds = LatLngBounds(southwest: LatLng(pickupLatLng.latitude, destinationLatLng.longitude), northeast: LatLng(destinationLatLng.latitude, pickupLatLng.longitude));
    //
    // }
    // else if(pickupLatLng.latitude > destinationLatLng.latitude){
    //   latLngBounds = LatLngBounds(southwest: LatLng(destinationLatLng.latitude, pickupLatLng.longitude), northeast: LatLng(pickupLatLng.latitude, destinationLatLng.longitude));
    //
    // }else{
    //   latLngBounds = LatLngBounds(southwest: pickupLatLng, northeast: destinationLatLng);
    // }
    // newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickupMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow: InfoWindow(title: initialPos.placename, snippet: "Your Location!"),
      position: pickupLatLng,
      markerId: MarkerId("pickupID"),

    );
    setState(() {
      markersSet.add(pickupMarker);
    });
    Circle pickupCircle = Circle(
        fillColor: Colors.amber,
        center: pickupLatLng,
        radius:12,
        strokeColor: Colors.amber,
        strokeWidth: 4,
        circleId: CircleId("pickupID")
    );
    Circle destinationCircle = Circle(
        fillColor: Colors.amber,
        center: destinationLatLng,
        radius:12,
        strokeColor: Colors.amber,
        strokeWidth: 4,
        circleId: CircleId("destinationID")
    );
    setState(() {
      circleSet.add(pickupCircle);
      circleSet.add(destinationCircle);
    });
  }
}
