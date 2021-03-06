import 'dart:async';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pazada/configs/MapsConfig.dart';
import 'package:pazada/configs/Universal_Variable.dart';
import 'package:pazada/dataHandler/appData.dart';
import 'package:pazada/models/PazabuyOrder.dart';
import 'package:pazada/models/pazabuyProduct.dart';
import 'package:pazada/models/pazship_order.dart';
import 'package:pazada/widgets/pazabuy_screen/Pazabuy_Payment.dart';
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
import 'package:location/location.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:location/location.dart' as lct;

class PazabuyQuery extends StatefulWidget {
  PazabuyProducts model;

  PazabuyQuery({this.model});
  @override
  _PazabuyQueryState createState() => _PazabuyQueryState();
}

class _PazabuyQueryState extends State<PazabuyQuery> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();
  String valueChoose,vehicleChoose;
  List listItem = ["PazPaz", "Willing to Wait"];
  List vehicleItem = ["Catablan - Pabor", "Habal","Padyak"];
  String CurrentPosition, mapLocation;
  Position currentPosition,desPosition;

  List<LatLng> pLinesCoordinates = [];
  Set<Polyline> polylineSet = {};
  Set<Marker> markersSet = {};
  Set<Circle> circleSet = {};
  PermissionStatus _permissionGranted;
  final Location location = Location();
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;
  var geoLocator = Geolocator();

  AssistantMethod assistantMethod = AssistantMethod();

  TextEditingController itemNameTextEditingController = new TextEditingController();
  TextEditingController itemValueTextEditingController = new TextEditingController();
  DatabaseReference rideRequestRef;
  String key = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("++");
    print(total);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.keyboard_arrow_left, color: Colors.white,)
        ),
        title: Text('Pazabuy', style: TextStyle(
          color: Colors.white,
        ),),

      ),
      body: SafeArea(
        child: Column(
            children: [Container(
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  // Padding(
                  //   padding: const EdgeInsets.all(10.0),
                  //   child: TextField(
                  //
                  //     controller: itemNameTextEditingController,
                  //     keyboardType: TextInputType.name,
                  //     decoration: InputDecoration(
                  //       prefixIcon:Icon(Icons.add_box_rounded),
                  //       enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber), borderRadius: BorderRadius.circular(10)),
                  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  //
                  //       labelText: "Item Name",
                  //       hintStyle: TextStyle(
                  //         color: Colors.grey,
                  //         fontSize: 10.0,
                  //       ),
                  //       labelStyle: TextStyle(
                  //         fontSize: 14.0,
                  //         fontFamily: 'bolt',
                  //       ),
                  //       filled: true,
                  //       fillColor: Colors.white,
                  //     ),
                  //     style: TextStyle(fontSize: 14.0),
                  //   ),
                  // ),
                  // Padding(
                  //
                  //   padding: const EdgeInsets.all(10.0),
                  //   child: TextField(
                  //     controller: itemValueTextEditingController,
                  //     keyboardType: TextInputType.number,
                  //     decoration: InputDecoration(
                  //       prefixIcon:Icon(Icons.monetization_on_outlined),
                  //       enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber), borderRadius: BorderRadius.circular(10)),
                  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  //
                  //       labelText: "Item Value",
                  //       hintStyle: TextStyle(
                  //         color: Colors.grey,
                  //         fontSize: 10.0,
                  //       ),
                  //       labelStyle: TextStyle(
                  //         fontSize: 14.0,
                  //         fontFamily: 'bolt',
                  //       ),
                  //       filled: true,
                  //       fillColor: Colors.white,
                  //     ),
                  //     style: TextStyle(fontSize: 14.0),
                  //   ),
                  // ),
                  //
                  // SizedBox(height: 20,),

                  Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height/5.2,
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
                            padding: const EdgeInsets.symmetric(horizontal:14.0, vertical:10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:[
                                Icon(Icons.location_on,color: Colors.amber,),
                                SizedBox(width: 5,),
                                Expanded(

                                  child: Container(


                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                                            : "Add Home", style: TextStyle(fontSize: 15, fontFamily: "bolt"),maxLines: 2,textAlign: TextAlign.left, overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                GestureDetector(
                                    onTap: ()async{
                                      assistantMethod.locatePosition();
                                      setState(() {
                                        mapbook = false;
                                        autoLoc = true;
                                      });
                                      await saveManualMapLocation();

                                      print('PRESS');

                                    },
                                    child: Icon(Icons.my_location_outlined)
                                ),
                              ],
                            ),
                          ),
                          // DividerWidget(),
                          //
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal:14.0,vertical: 10),
                          //   child: Row(
                          //     children: [
                          //       Icon(Icons.location_on,color: Colors.red,),
                          //       SizedBox(width: 5,),
                          //       Expanded(
                          //         child: GestureDetector(
                          //           //onTap: pazakay,
                          //           child: Container(
                          //
                          //             child: Padding(
                          //               padding: const EdgeInsets.symmetric(horizontal:30, vertical: 25),
                          //               child: Text(mapbook == true && Provider.of<AppData>(context).destinationLocation2!= null
                          //                   ?  Provider.of<AppData>(context).destinationLocation2.placename
                          //                   : autoLoc ==true && Provider.of<AppData>(context).pickUpLocation!= null
                          //                   ? Provider.of<AppData>(context).pickUpLocation.placename
                          //                   : "Add Home", style: TextStyle(fontSize: 15, fontFamily: "bolt"),maxLines: 2,textAlign: TextAlign.left, overflow: TextOverflow.ellipsis,
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //       GestureDetector(
                          //           onTap: (){
                          //             _requestPermission();
                          //           },
                          //           child: Icon(Icons.my_location_outlined)
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Image.network(widget.model.thumbnailUrl.toString()),
                          // ),

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

                      print(average);
                      await getPlaceDirection();
                      savePazabuyBooking();
                      //Navigator.pop(context, "obtainDirection");
                      pazakayPayment();
                      //setStat();
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
  void pazakay2 (){

    Navigator.push(context, MaterialPageRoute(builder: (context)=> PazadaScreen2()));
  }
  void pazakayPayment (){

    Navigator.push(context, MaterialPageRoute(builder: (context)=> PazabuyPayments(model: widget.model)));
  }
  void getPosition (){


    setState(() {
      CurrentPosition = Provider.of<AppData>(context).pickUpLocation.placename;

    });

  }


  void savePazabuyBooking(){
    PazabuyOrder pazabuyOrder = new PazabuyOrder();
    // pazabuyOrder.itemName = widget.model.productName;
    //pazabuyOrder.itemValue = widget.model.price.toString();
    // pazabuyOrder.itemValue = widget.model.thumbnailUrl;
    pazabuyOrder.stats = false;
    Provider.of<AppData>(context, listen: false).updatePazabuyOrder(pazabuyOrder);

    rideRequestRef = FirebaseDatabase.instance.reference().child("Ride_Request").child(rideKey);
    Map pazShipBooking = {
      // "item_name": widget.model.sellerName,
      // "item_value": widget.model.price,
      // "thumbnailUrl": widget.model.thumbnailUrl,

      "Grand_Total": total.toString(),

    };

    rideRequestRef.update({
      "Grand_Total": total.toString(),

    });
    pazabuyOrder.key = rideRequestRef.key;
    print("???????????????" + pazabuyOrder.key);
    Provider.of<AppData>(context, listen: false).updatePazabuyOrder(pazabuyOrder);

  }
  void setStat(){
    PazabuyOrder pazabuyOrder = new PazabuyOrder();

    setState(() {
      pazabuyOrder.stats = false;
    });
    Provider.of<AppData>(context, listen: false).updatePazabuyOrder(pazabuyOrder);
  }


  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;  Future<void> saveManualMapLocation()async{
    String userId = firebaseUser.uid;
    var finalPos = Provider.of<AppData>(context, listen: false).destinationLocation;
    Map manualMapBooking = {
      "map_location": finalPos

    };
    usersRef.child(userId).child("manual_booking").set(manualMapBooking);

  }
  Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult =
      await location.requestPermission();
      setState(() {
        _permissionGranted = permissionRequestedResult;
      });
    }
    Navigator.push(context, MaterialPageRoute(builder: (context)=> PazadaScreen()));
  }
  Future <void> getPlaceDirection()async{
    var initialPos = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).pickUpLocation;
    //var pickupLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var destinationLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    //showDialog(context: context, builder: (BuildContext context)=> ProgressDialog(message: "Please wait...."));

    var details = await AssistantMethod.obtainPlaceDirectionDetails(destinationLatLng, destinationLatLng);
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

    Marker pickupMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow: InfoWindow(title: initialPos.placename, snippet: "Your Location!"),
      position: destinationLatLng,
      markerId: MarkerId("pickupID"),

    );
    setState(() {
      markersSet.add(pickupMarker);
    });
    Circle pickupCircle = Circle(
        fillColor: Colors.amber,
        center: destinationLatLng,
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
