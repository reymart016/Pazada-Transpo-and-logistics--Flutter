import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pazada/assistants/assistantMethod.dart';
import 'package:pazada/assistants/geoFireAssistant.dart';
import 'package:pazada/configs/MapsConfig.dart';
import 'package:pazada/configs/Universal_Variable.dart';
import 'package:pazada/dataHandler/appData.dart';
import 'package:pazada/main.dart';
import 'package:pazada/models/directionDetails.dart';
import 'package:pazada/models/nearbyAvalableDrivers.dart';
import 'package:pazada/models/pazabuyMenus.dart';
import 'package:pazada/models/pazabuyProduct.dart';
import 'package:pazada/models/pazada_driver.dart';
import 'package:pazada/widgets/pazada_screen.dart';
import 'package:pazada/widgets/shared/driverInfo.dart';
import 'package:pazada/widgets/shared/noDriverAvailableDialog.dart';
import 'package:pazada/widgets/shared/pazabuydriverinfo.dart';
import 'package:pazada/widgets/shared/progressDialog.dart';
import 'package:pazada/widgets/shared/searchingDriver.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

class PazabuyPayments extends StatefulWidget {
  PazabuyProducts model;
  final double totalAmount;
  PazabuyPayments({this.model, this.totalAmount});


  static const String idScreen = "PazakayPayment";
  @override
  _PazabuyPaymentsState createState() => _PazabuyPaymentsState();
}


class _PazabuyPaymentsState extends State<PazabuyPayments> {
  List payments = ["Cash", "Gcash (Coming Soon)"];
  String paymentChoose;
  Position currentPosition,desPosition;

  List<LatLng> pLinesCoordinates = [];
  Set<Polyline> polylineSet = {};
  Set<Marker> markersSet = {};
  Set<Circle> circleSet = {};
  String orderId = DateTime.now().millisecondsSinceEpoch.toString();
  DirectionDetails tripDirectionDetails;




  List<NearbyAvailableDrivers> availableDrivers;
  BitmapDescriptor nearbyIcon;
  String state = "normal";

  AssistantMethod assistantMethod = AssistantMethod();
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;



  final log = Logger();
  PazadaDriver pazadaDriver = new PazadaDriver();




  void locatePosition()async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    currentPosition = position;
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new CameraPosition(target: latLngPosition, zoom: 16);
    //newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    print("POSITION::$currentPosition");
    String address = await AssistantMethod.searchCoordinatesAddress(position, context);
    print("this is your Address::" + address);
    initGeofireListener();

  }




  void initState() {
    // TODO: implement initState
    super.initState();
    getPlaceDirection();
    locatePosition();
    _isVisible();
  }
  void checkStatus(){
    if(Provider.of<AppData>(context).destinationLocation2!= null){
      setState(() {
        mapbook = true;
        autoLoc = false;
      });
    }else{
      mapbook = false;
      autoLoc = true;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(

      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text("Review your Booking", style: TextStyle(fontSize: 20, fontFamily: "bolt-bold"),),

        ),

        body: Stack(
            alignment: Alignment.center,
            children:[
              Positioned(
                left: 0.0,
                right: 0.0,
                top: 0.0,
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height/1.4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                      // boxShadow:[
                      //   BoxShadow(
                      //     color: Colors.black,
                      //     blurRadius: 16,
                      //     spreadRadius: .5,
                      //     offset: Offset(.7, .7),
                      //   )
                      // ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [



                          SizedBox(height: 16.0,),

                          Container(
                            height: MediaQuery.of(context).size.height/5.5,
                            width: double.infinity,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 3,color: Colors.amber),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top:10.0, bottom: 10, right: 20, left: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.only(top:5.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Trike",style: TextStyle(fontFamily: "bolt-bold",fontSize: 30, color: Colors.amber),
                                        ),
                                        Text("Affordable ride for every Juan. \nMax Capacity: 4 people.",style:TextStyle(fontFamily: "bolt",fontSize: 17)),
                                        SizedBox(height: 10,),
                                        Container(child: Row(
                                          children: [
                                            Icon(Icons.speed,color: Colors.grey,size: 12,),
                                            SizedBox(width: 5,),
                                            Text("0.5 x 0.4 x 0.5 Meter. Up to 4 people", style: TextStyle(fontFamily: "bolt",fontSize: 12, color: Colors.grey),)
                                          ],
                                        ),)
                                      ],

                                    ),
                                  ),

                                  SvgPicture.asset('images/svg/trikeA.svg',height: 50,),

                                ],

                              ),
                            ),
                          ),
                          SizedBox(height: 10,),

                          // Container(
                          //   width: MediaQuery.of(context).size.width * .96,
                          //   decoration: BoxDecoration(
                          //     color: Colors.grey[200],
                          //     borderRadius: BorderRadius.circular(5),
                          //
                          //   ),
                          //   child: Padding(
                          //     padding: const EdgeInsets.symmetric(horizontal:5,),
                          //     child: DropdownButton(
                          //
                          //       underline: SizedBox(),
                          //       isExpanded: true,
                          //       icon: Icon(Icons.arrow_drop_down_circle_outlined),
                          //       hint: Text("Select Payment",style: TextStyle(fontSize: 15, fontFamily: "bolt"),textAlign: TextAlign.center, ),
                          //       value: paymentChoose,
                          //       onChanged:(paymentValue){
                          //         setState(() {
                          //           paymentChoose = paymentValue;
                          //         });
                          //       },
                          //       items: payments.map((vehicleItem){
                          //         return DropdownMenuItem(
                          //
                          //           value: vehicleItem,
                          //           child: Text(vehicleItem,style: TextStyle(fontSize: 15, fontFamily: "bolt"),textAlign: TextAlign.center,),
                          //         );
                          //       }).toList(),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: 10,),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(

                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Origin:', style: TextStyle(fontFamily: "bolt",fontSize: 11),),
                                          SizedBox(height: 10,),
                                          Text('Destination:', style: TextStyle(fontFamily: "bolt",fontSize: 11),),
                                          SizedBox(height: 10,),
                                          Text('            ', style: TextStyle(fontFamily: "bolt",fontSize: 11),),
                                          SizedBox(height: 10,),
                                          Text('            ', style: TextStyle(fontFamily: "bolt",fontSize: 11),),
                                          // SizedBox(height: 10,),
                                          // Visibility(visible: isvisible,
                                          //     child: Text('PazShip Item:', style: TextStyle(fontFamily: "bolt",fontSize: 11),)),
                                          // SizedBox(height: 10,),
                                          // Visibility(visible: isvisible,
                                          //     child: Text('PazShip Item Value:', style: TextStyle(fontFamily: "bolt",fontSize: 11),)),
                                        ],
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(Provider.of<AppData>(context).destinationLocation2!= null && mapbook == true
                                                ?  Provider.of<AppData>(context).destinationLocation2.placename
                                                : Provider.of<AppData>(context).pickUpLocation!= null && autoLoc == true
                                                ? Provider.of<AppData>(context).pickUpLocation.placename
                                                : "Add Home", style: TextStyle(fontSize: 11, fontFamily: "bolt"),maxLines: 1,textAlign: TextAlign.left, overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 10,),
                                            Text(Provider.of<AppData>(context).destinationLocation2!= null && mapbook == true
                                                ?  Provider.of<AppData>(context).destinationLocation2.placename
                                                : Provider.of<AppData>(context).pickUpLocation!= null && autoLoc == true
                                                ? Provider.of<AppData>(context).pickUpLocation.placename
                                                : "Add Home", style: TextStyle(fontSize: 11, fontFamily: "bolt"),maxLines: 1,textAlign: TextAlign.left, overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 10,),
                                            Text('           '
                                              , style: TextStyle(fontFamily: "bolt",fontSize: 11),),
                                            SizedBox(height: 10,),

                                            // Text(Provider.of<AppData>(context, listen: false).pazShipOrder.key != null ?
                                            // Provider.of<AppData>(context,listen: false).pazShipOrder.key : ''
                                            //   , style: TextStyle(fontFamily: "bolt",fontSize: 11),),
                                            Text('          '
                                              , style: TextStyle(fontFamily: "bolt",fontSize: 11),),
                                            // SizedBox(height: 10,),
                                            // Visibility(visible: isvisible,
                                            //   child: Text(Provider.of<AppData>(context, listen: false).pazShipOrder != null ?
                                            //   Provider.of<AppData>(context, listen: false).pazShipOrder.itemName :testest
                                            //     , style: TextStyle(fontFamily: "bolt",fontSize: 11),),
                                            // ),
                                            // SizedBox(height: 10,),
                                            // Visibility(visible: isvisible,
                                            //   child: Text(Provider.of<AppData>(context, listen: false).pazShipOrder != null ?
                                            //   Provider.of<AppData>(context, listen: false).pazShipOrder.itemValue :testest
                                            //     , style: TextStyle(fontFamily: "bolt",fontSize: 11),),
                                            // ),
                                          ],

                                        ),
                                      )
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),

                        ],

                      ),
                    ),
                  ),
                ),
              ),
              SizedBox.expand(
                child: DraggableScrollableSheet(
                  initialChildSize: .23,
                  minChildSize: .23,
                  maxChildSize: .23,
                  builder: (BuildContext c, s){
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft:  Radius.circular(10),

                          ),
                          boxShadow: [BoxShadow(
                            color: Colors.grey,
                            blurRadius: 18,

                          )]
                      ),
                      child: ListView(
                        controller: s,
                        children: [
                          Center(
                            child: Container(
                              height: 8,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(5)
                              ),

                            ),

                          ),
                          SizedBox(height: 20,),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:[ Text("Total"),
                                Text("Php "+total.toStringAsFixed(2),style: TextStyle(fontFamily: "bolt",fontSize: 30,),
                                  textAlign: TextAlign.right,
                                ),]
                          ),
                          SizedBox(height: 20,),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 53,
                                  width: MediaQuery.of(context).size.width * .92,
                                  child: RaisedButton(

                                    shape: new RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0)),
                                    color: Colors.amber,
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Text('Request', style: TextStyle(
                                          color: Colors.white,


                                        ),

                                        ),
                                      ),
                                    ),
                                    onPressed: ()async{
                                      searchingDriver();
                                      //pazada();
                                      //driverInfo();
                                      availableDrivers = GeoFireAssistant.nearbyAvailableDriversList;



                                      saveRideRequest();
                                      await searchNearestDriver();
                                      print('PRESSED');
                                      print(availableDrivers);
                                      setState(() {
                                        state = "requesting";
                                        // destinationContainer =0;
                                        // loadingRider = 280;
                                      });
                                    },
                                  ),
                                ),

                              ] ),
                        ],
                      ),
                    );
                  },
                ),
              ),

            ]


        ),
      ),
    );

  }
  void _isVisible(){
    if(Provider.of<AppData>(context, listen: false).pazShipOrder != null){
      setState(() {
        isvisible = true;
      });
    }
  }

  void saveRideRequest()async{
    print("SAVEEEEEEEEEEEEEEEEEEEEEEEE");
    var pickUp;
    var dropOff;

    // if(Provider.of<AppData>(context, listen: false).pazabuyOrder.key!=null && Provider.of<AppData>(context, listen: false).pazabuyOrder.stats == false) {

      print(Provider
          .of<AppData>(context, listen: false)
          .pazabuyOrder.key);
      print(Provider.of<AppData>(context, listen: false).pazabuyOrder.stats);
   // }
    //await searchNearestDriver();
    if(Provider.of<AppData>
      (context, listen: false).pickUpLocation!=null && autoLoc == true){
      pickUp = Provider.of<AppData>(context, listen: false).pickUpLocation;
   dropOff = Provider.of<AppData>(context, listen: false).pickUpLocation;
    }else{
      pickUp = Provider.of<AppData>(context, listen: false).destinationLocation2;
    dropOff = Provider.of<AppData>(context, listen: false).destinationLocation2;
    }

    //var dropOff = Provider.of<AppData>(context, listen: false).destinationLocation;
    var fare = AssistantMethod.calculateFares(tripDirectionDetails);
    setState(() {
      pointA = pickUp.placename;
      pointB = dropOff.placename;
    });


    print(pickUp.latitude.toString());
    print(pickUp.longitude.toString());
    Map pickUpCoordinates ={
      "latitude": pickUp.latitude.toString(),
      "longitude": pickUp.longitude.toString(),
    };
    Map destinationCoordinates ={
      "latitude": dropOff.latitude.toString(),
      "longitude": dropOff.longitude.toString(),
    };
    Map rideInfoMap ={
      "driver_id": "waiting",
      "payment_method": "cash",
      "pickup": pickUpCoordinates,
      "fares": fare,
      "destination": destinationCoordinates,
      "created_at": DateTime.now().toString(),
      "passenger_name": usersCurrentInfo.name,
      "passenger_phone": usersCurrentInfo.phone,
      "pickup_address": pickUp.placename,
      "destination_address": dropOff.placename,
    };
    rideRequestRef = FirebaseDatabase.instance.reference().child("Ride_Request").child(
            Provider.of<AppData>(context, listen: false).pazabuyOrder.key);
   await  rideRequestRef.update({//dito nagkakapasahan ng data sa pazaqbuy
      "passengerID": currentfirebaseUser.uid,
      "driver_id": "waiting",
      "payment_method": "cash",
      "pickup": pickUpCoordinates,
      "fares": 49.00,
      "destination": destinationCoordinates,
      "created_at": DateTime.now().toString(),
      "passenger_name": usersCurrentInfo.name,
      "passenger_phone": usersCurrentInfo.phone,
      "pickup_address": pickUp.placename,
      "destination_address": dropOff.placename,
      "sellerUID": sellerid,
      "seller_name": sellername,
      "seller_number": sellerphone,
      "quantity": quantity,
      "orderId": orderId,
      "item_value": item_value,



    });
    Map<String, dynamic> historyData = {
      "address": pickUp.placename,
      "Grand_Total": total,
      "orderBy": sharedPreferences.getString("uId"),
      "productIDs": sharedPreferences.getStringList("userCart"),
      "paymentDetails": "Cash on Delivery",
      "orderTime": orderId,
      "isSuccess": true,
      "sellerUID": sellerid,
      "riderUID": "",
      "status": "normal",
      "orderId": orderId,
    };
    FirebaseFirestore.instance.collection('PazadaUsers').doc(currentfirebaseUser.uid).collection("PazabuyOrders")
        .doc(orderId).set(historyData).then((value){
      final productsRef = FirebaseFirestore.instance.collection("PazabuyOrders"); //SAVE AS MAIN COLLECTION
      productsRef.doc(orderId).set({
        "address": pickUp.placename,
        "Grand_Total": total,
        "orderBy": sharedPreferences.getString("uId"),
        "productIDs": sharedPreferences.getStringList("userCart"),
        "paymentDetails": "Cash on Delivery",
        "orderTime": orderId,
        "isSuccess": true,
        "sellerUID": sellerid,
        "riderUID": "",
        "status": "normal",
        "orderId": orderId,



      }).whenComplete((){
        clearCartNow(context);
        setState(() {
          orderId="";
          //Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          Fluttertoast.showToast(msg: "Congratulations, Order has been placed successfully.");
        });
      });
    });
    Map<String, dynamic> userData = {


      "userAddress": pickUp.placename,
    };

    FirebaseFirestore.instance.collection('PazadaUsers').doc(firebaseUser.uid).update(userData);




    setState(() {
      rideRequestId = rideRequestRef.key;
      fareText = fare.toString();
    });
    print("RIDE id::" + rideRequestId);
    //-- get the driver info using streamsubscription---//

    rideStreamSubscription = rideRequestRef.onValue.listen((event) {
      if(event.snapshot.value == null){
        return;
      }
      if(event.snapshot.value["status"] != null){
        passDriverInfo();
        randomID = event.snapshot.value["uniqueID"];

        pazadaDriver.rideStatus = event.snapshot.value["status"];
        rideStatus = event.snapshot.value['status'].toString();
        setState(() {
          rideType = event.snapshot.value['Pazabuy'];// gagong code to
        });
        //username = event.snapshot.value['driver_name'].toString();
        print("================================================");
        print("      NOT NULL             ");
        print(rideStatus);
        print(username);
        print(rideType);
        print(":::::::::::::::::::::::::::::::::::::::::::::::::");

      }
      if(event.snapshot.value["driver_name"] != null && event.snapshot.value["driver_phone"] != null && event.snapshot.value["vehicle_details"] != null){
        setState(() {
          username = event.snapshot.value["driver_name"].toString();
          driver_phone = event.snapshot.value["driver_phone"].toString();
          vehicle_details = event.snapshot.value["vehicle_details"].toString();
          qrData = event.snapshot.value["QR"].toString();
          pazadaDriver.username = username;
          pazadaDriver.number = driver_phone;
          pazadaDriver.vehicle_details = vehicle_details;

        });

      }
      Provider.of<AppData>(context, listen: false).updatepazadaDriver(pazadaDriver);
      // if(event.snapshot.value["driver_phone"] != null){
      //   setState(() {
      //     driver_phone = event.snapshot.value["driver_phone"].toString();
      //   });
      // }
      // if(event.snapshot.value["vehicle_details"] != null){
      //   setState(() {
      //     vehicle_details = event.snapshot.value["vehicle_details"].toString();
      //   });
      //   rideStreamSubscription.cancel();
      // }
      //
      //
      // if(event.snapshot.value != null){
      //   Map DriverInfo = event.snapshot.value;
      //
      //     setState(() {
      //       username = event.snapshot.value['driver_name'].toString();
      //       number = event.snapshot.value['driver_phone'].toString();
      //       email = event.snapshot.value['email'].toString();
      //       vehicle_details =event.snapshot.value['vehicle_details'].toString();
      //       vehicle_model = event.snapshot.value['vehicle_model'].toString();
      //       vehicle_color = event.snapshot.value['vehicle_color'].toString();
      //       vehicle_plateNum = event.snapshot.value['vehicle_plateNum'].toString();
      //       vehicle_type = event.snapshot.value['vehicle_type'].toString();
      //     });
      // }



      if(rideStatus == 'accepted'){
        Navigator.pop(context);
        if(rideType == true){
          setState(() {
            pazabuyDriverInfo();
            print(":::::::::::::::::::::::::::::::::::::::::::::::::");
            print(":::::::::::::::::::::::::::::::::::::::::::::::::");
            qrData = event.snapshot.value["QR"];
            qrData2 =  event.snapshot.value["uniqueID"];
            print(":::::::::::::::::::::::::::::::::::::::::::::::::");
            print(":::::::::::::::::::::::::::::::::::::::::::::::::");
          });
          print(qrData);
        }else{
          driverInfo();
        }



        //closeCurrentDialog();
        setState(() {
          rideStatus = "";
        });

      }
    });

  }
  void pazabuyDriverInfo()async{

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => PazabuyDriverInfo()
    );



  }
  Future <void> getPlaceDirection()async{

    var pickUp;

    var pickupLatLng;
    var finalPos;
    //var initialPos = Provider.of<AppData>(context, listen: false).pickUpLocation;
    // var finalPos = Provider.of<AppData>(context, listen: false).destinationLocation;
    //var pickupLatLng = LatLng(initialPos.latitude, initialPos.longitude);

    if(Provider.of<AppData>(context, listen: false).pickUpLocation!=null && autoLoc == true){
      pickUp = Provider.of<AppData>(context, listen: false).pickUpLocation;
      finalPos = Provider.of<AppData>(context, listen: false).pickUpLocation;
      pickupLatLng = LatLng(pickUp.latitude, pickUp.longitude);
    }else{
      pickUp = Provider.of<AppData>(context, listen: false).destinationLocation2;
      finalPos = Provider.of<AppData>(context, listen: false).destinationLocation2;
      pickupLatLng = LatLng(pickUp.latitude, pickUp.longitude);
    }
    var destinationLatLng = LatLng(finalPos.latitude, finalPos.longitude);
    //showDialog(context: context, builder: (BuildContext context)=> ProgressDialog(message: "Please wait...."));

    print(pickupLatLng);
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


    Marker pickupMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      // infoWindow: InfoWindow(title: initialPos.placename, snippet: "Your Location!"),
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
  void passDriverInfo()async{
    DataSnapshot dataSnapshot = await usersRef.child("Ride_Request").child(rideRequestId).once();
    Map driverInformation = dataSnapshot.value;
    setState(() {
      pazadaDriver.driverID = driverInformation['driver_id'];
      pazadaDriver.username = driverInformation['driver_name'];
      pazadaDriver.vehicle_details = driverInformation['vehicle_details'];
      pazadaDriver.vehicle_plateNum = driverInformation['vehicle_plateNum'].toString();
      pazadaDriverID =  pazadaDriver.driverID;
      username = Provider.of<AppData>(context, listen: false).pazadaDriver.username;
      vehicle_plateNum = Provider.of<AppData>(context, listen: false).pazadaDriver.vehicle_plateNum;
      vehicle_details = Provider.of<AppData>(context, listen: false).pazadaDriver.vehicle_details;
    });
    print(":::::::::::::::::::::::::::::::::::::::::");
    print(Provider.of<AppData>(context, listen: false).pazadaDriver.username);
    print(Provider.of<AppData>(context, listen: false).pazadaDriver.vehicle_details);
    print(Provider.of<AppData>(context, listen: false).pazadaDriver.vehicle_plateNum);
    print(Provider.of<AppData>(context, listen: false).pazadaDriver.driverID);
    print(":::::::::::::::::::::::::::::::::::::::::");

  }
  void searchNearestDriver(){

    print("GUMAGANA!!!");


    //showDialog(context: context,barrierDismissible: false, builder: (BuildContext context)=> ProgressDialog(message: "Please wait...."));
    if(availableDrivers.length == 0){

      noDriverFound();
      Navigator.pop(context);
      cancelRideRequest();
      //rideRequestRef.remove();
      return;

    }
    //Navigator.pop(context);
    var driver = availableDrivers[0];
    print("GUMAGANA!!ATA");
    print(driver.toString());
    availableDrivers.removeAt(0);
    notifyDriver(driver);
  }

  void notifyDriver(NearbyAvailableDrivers driver){
    keyy = rideRequestRef.key;
    String token ="";
    setState(() {
      driverID = driver.key;//this will pass the driver UID to a global variable and can be use later
    });
    driversRef.child(driver.key).child("newRide").set(rideRequestRef.key);
    driversRef.child(driver.key).child("token").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value != null){
        token = dataSnapshot.value.toString();
        AssistantMethod.sendNotificationToDriver(token, context, rideRequestRef.key);
      }else{
        return;
      }
      const oneSecondPassed = Duration(seconds: 1);
      var timer = Timer.periodic(oneSecondPassed, (timer) {
        if(state != "requesting"){
          driversRef.child(driver.key).child("newRide").set("cancelled");
          driversRef.child(driver.key).child("newRide").onDisconnect();
          driveRequesttimeOut = 40;
          timer.cancel();
        }
        driversRef.child(driver.key).child("newRide").onValue.listen((event) {
          if(event.snapshot.toString() == "accepted"){
            driversRef.child(driver.key).child("newRide").onDisconnect();

            driveRequesttimeOut = 40;
            timer.cancel();
          }
        });


        driveRequesttimeOut = driveRequesttimeOut - 1;
        if(driveRequesttimeOut == 0){
          driversRef.child(driver.key).child("newRide").set("timeout");
          driversRef.child(driver.key).child("newRide").onDisconnect();
          driveRequesttimeOut = 40;
          timer.cancel();
          //searchNearestDriver();
        }
      });
      print(token);
    });

  }
  void pazada (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> PazadaScreen()));
  }
  void noDriverFound()
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => NoDriverAvailableDialog()
    );

  }
  void searchingDriver(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => SearchingDriver()
    );
  }
  void driverInfo(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => DriverInfo()
    );

  }

  void closeCurrentDialog(){
    Navigator.pop(context);
  }
  void cancelRideRequest(){
    //rideRequestRef.remove();
    setState(() {
      state = "normal";
    });
  }


  void initGeofireListener(){
    print("FUCKING MARKERSs");
    Geofire.initialize("availableDrivers");
    Geofire.queryAtLocation(currentPosition.latitude, currentPosition.longitude, 15).listen((map) {
      print(currentPosition.latitude + currentPosition.longitude);
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyAvailableDrivers nearbyAvailableDrivers = NearbyAvailableDrivers();
            nearbyAvailableDrivers.key = map['key'];
            nearbyAvailableDrivers.latitude = map['latitude'];
            nearbyAvailableDrivers.longitude = map['longitude'];
            GeoFireAssistant.nearbyAvailableDriversList.add(nearbyAvailableDrivers);

            updateAvailableDriversOnMap();

            break;

          case Geofire.onKeyExited:
            GeoFireAssistant.removeDriverFromList(map['key']);
            updateAvailableDriversOnMap();
            break;

          case Geofire.onKeyMoved:
            NearbyAvailableDrivers nearbyAvailableDrivers = NearbyAvailableDrivers();
            nearbyAvailableDrivers.key = map['key'];
            nearbyAvailableDrivers.latitude = map['latitude'];
            nearbyAvailableDrivers.longitude = map['longitude'];
            GeoFireAssistant.updateDriverNearbylocation(nearbyAvailableDrivers);
            // Update your key's location
            break;

          case Geofire.onGeoQueryReady:
          // All Intial Data is loaded
            updateAvailableDriversOnMap();

            break;
        }
      }

      setState(() {});
      //tt
    });

  }

  void updateAvailableDriversOnMap(){
    setState(() {
      markersSet.clear();
    });
    Set<Marker> tMarkers = Set<Marker>();
    for(NearbyAvailableDrivers driver in GeoFireAssistant.nearbyAvailableDriversList){
      LatLng driverAvailablePosition = LatLng(driver.latitude, driver.longitude);
      Marker marker = Marker(
        markerId: MarkerId('driver${driver.key}'),
        position: driverAvailablePosition,
        icon: nearbyIcon,


      );
      tMarkers.add(marker);
      setState(() {

        markersSet = tMarkers;
      });
    }
  }
  void createIconMarker(){
    if(nearbyIcon == null){
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(.2, .2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, 'images/pazadamarker.png').then((value){
        nearbyIcon =value;
      }
      );
    }
  }


  addOrderDetails()
  {
    var pickUp;
    var dropOff;

    if(Provider.of<AppData>(context, listen: false).pazabuyOrder.key!=null && Provider.of<AppData>(context, listen: false).pazabuyOrder.stats == false) {
      rideRequestRef =
          FirebaseDatabase.instance.reference().child("Ride_Request").child(
              Provider
                  .of<AppData>(context, listen: false)
                  .pazabuyOrder.key);
    }else{
      rideRequestRef = FirebaseDatabase.instance.reference().child("Ride_Request").push();
    }
    //await searchNearestDriver();
    if(Provider.of<AppData>(context, listen: false).pickUpLocation!=null && autoLoc == true){
      pickUp = Provider.of<AppData>(context, listen: false).pickUpLocation;
      dropOff = Provider.of<AppData>(context, listen: false).pickUpLocation;
    }else{
      pickUp = Provider.of<AppData>(context, listen: false).destinationLocation2;
      dropOff = Provider.of<AppData>(context, listen: false).destinationLocation2;
    }

    //var dropOff = Provider.of<AppData>(context, listen: false).destinationLocation;
    var fare = AssistantMethod.calculateFares(tripDirectionDetails);
    setState(() {
      pointA = pickUp.placename;
      pointB = dropOff.placename;
    });
    writeOrderDetailsForUser({
      "address": pickUp.placename,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences.getString("uId"),
      "productIDs": sharedPreferences.getStringList("userCart"),
      "paymentDetails": "Cash on Delivery",
      "orderTime": orderId,
      "isSuccess": true,
      "sellerUID": widget.model.sellerUID,
      "riderUID": "",
      "status": "normal",
      "orderId": orderId,
    });

    writeOrderDetailsForSeller({

      "address": pickUp.placename,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences.getString("uid"),
      "productIDs": sharedPreferences.getStringList("userCart"),
      "paymentDetails": "Cash on Delivery",
      "orderTime": orderId,
      "isSuccess": true,
      "sellerUID": widget.model.sellerUID,
      "riderUID": "",
      "status": "normal",
      "orderId": orderId,
    }).whenComplete((){
      clearCartNow(context);
      setState(() {
        orderId="";
        //Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        Fluttertoast.showToast(msg: "Congratulations, Order has been placed successfully.");
      });
    });
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async
  {
    await FirebaseFirestore.instance
        .collection("PazadaUsers")
        .doc(sharedPreferences.getString("uId"))
        .collection("PazabuyOrders")
        .doc(orderId)
        .set(data);
  }

  Future writeOrderDetailsForSeller(Map<String, dynamic> data) async
  {
    await FirebaseFirestore.instance
        .collection("PazabuyOrders")
        .doc(orderId)
        .set(data);
  }


}

