import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pazada/assistants/assistantMethod.dart';
import 'package:pazada/assistants/geoFireAssistant.dart';
import 'package:pazada/configs/MapsConfig.dart';
import 'package:pazada/dataHandler/appData.dart';
import 'package:pazada/models/directionDetails.dart';
import 'package:pazada/models/nearbyAvalableDrivers.dart';
import 'package:pazada/widgets/dropOff_screen/dropOff_screen.dart';
import 'package:pazada/widgets/login/login_screen.dart';
import 'package:pazada/widgets/pazada_screen/payment_panel.dart';
import 'package:pazada/widgets/shared/divider.dart';
import 'package:pazada/widgets/shared/loading.dart';
import 'package:pazada/widgets/shared/navbar.dart';
import 'package:pazada/widgets/shared/progressDialog.dart';
import 'package:pazada/widgets/signup/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as lct;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_geofire/flutter_geofire.dart';


class PazadaScreen extends StatefulWidget {
  static const String idScreen = "pazadaScreen";


  @override
  _PazadaScreenState createState() => _PazadaScreenState();
}

class _PazadaScreenState extends State<PazadaScreen> with TickerProviderStateMixin {
  var res;
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;
  List<Marker> _markers = [];
  String finallat = "";
  String finallong = "";
  double FinalLat, FinalLong;
  bool searching = false;
  lct.Location location;
  String coordinates = "";
  TextEditingController destinationAddress = TextEditingController();
  TextEditingController contactNumber = TextEditingController();

  Position currentPosition,desPosition;

  List<LatLng> pLinesCoordinates = [];
  Set<Polyline> polylineSet = {};
  Set<Marker> markersSet = {};
  Set<Circle> circleSet = {};

  double rideDetailsContainer = 0;
  double destinationContainer = 280;
  double loadingRider = 0;


  List payments = ["Cash", "Gcash"];
  String paymentChoose;

  DirectionDetails tripDirectionDetails;

  DatabaseReference rideRequestRef;

  var geoLocator = Geolocator();
  double bottomPaddingofMap = 0;

  bool nearbyAvailableDriverKeyLoaded = false;
  BitmapDescriptor nearbyIcon;

  String manualBook ='';



  void displayRideDetailsContainer()async{
    await getPlaceDirection();

    setState(() {
        destinationContainer = 0;
        rideDetailsContainer =280;
    });
    saveRideRequest();
  }
  cancelSearch(){
    Navigator.pop(context);
    rideRequestRef.remove();
  }
  void saveRideRequest(){

    rideRequestRef = FirebaseDatabase.instance.reference().child("Ride_Request").push();
    var pickUp = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var dropOff = Provider.of<AppData>(context, listen: false).destinationLocation;


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
      "destination": destinationCoordinates,
      "created_at": DateTime.now().toString(),
      "passenger_name": usersCurrentInfo.name,
      "passenger_phone": usersCurrentInfo.phone,
      "pickup_address": pickUp.placename,
      "destination_address": dropOff.placename,
    };

    rideRequestRef.set(rideInfoMap);

  }

  void cancelRideRequest(){
      rideRequestRef.remove();
  }




  void locatePosition()async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    currentPosition = position;
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new CameraPosition(target: latLngPosition, zoom: 16);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    print("POSITION::$currentPosition");
    String address = await AssistantMethod.searchCoordinatesAddress(position, context);
    print("this is your Address::" + address);
    initGeofireListener();

  }



  static const LatLng _center = const LatLng(37.42796133580664, -122.085749655962);

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  _onAddMarkerButton(LatLng tappedPoint){
    print(tappedPoint);
    setState(() {
      _markers = [];
      _markers.add(
          Marker(
            draggable: true,
            onDragEnd: (dragEndPosition){
              print(dragEndPosition);
            },
            markerId: MarkerId(tappedPoint.toString()),
            position:tappedPoint,
            infoWindow: InfoWindow(
              title: 'ADDRESS TITLE',
              snippet: 'This is snippet',

            ),

          )
      );
    });

  }


  Widget button(Function function, IconData icon){
    return FloatingActionButton(onPressed: function,
    materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.amber,
      child: Icon(
        icon,
        size: 36,
      ),
    );
  }
  //----------------------config for center marker-----------------------/

  @override
  void initState() {
    AssistantMethod.getCurrentOnlineInformation(); //BOOKING PART
    requestPerms();
    super.initState();
  }



//Permiso
  requestPerms() async {
    Map<Permission, PermissionStatus> statuses =
    await [Permission.locationAlways].request();

    var status = statuses[Permission.locationAlways];
    if (status == PermissionStatus.denied) {
      requestPerms();
    } else {
      gpsAnable();
    }
  }

// GPS
  gpsAnable() async {
    location = lct.Location();
    bool statusResult = await location.requestService();
    print("DESLOCATION::" + location.toString());
    if (!statusResult) {
      gpsAnable();
    }
  }
  //-------------------------------------/
  @override
  Widget build(BuildContext context) {
    createIconMarker();
    return Scaffold(

      body: Stack(
        children: [

          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingofMap),
            mapType: MapType.normal,
              // onTap: _onAddMarkerButton,
              markers: markersSet,
              circles: circleSet,
              myLocationButtonEnabled: true,
              polylines: polylineSet,
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
               zoomControlsEnabled: true,

            onMapCreated: (GoogleMapController controller)async{
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              print("THIS TEXT IS WORKING::");
              locatePosition();
              setState(() {
                bottomPaddingofMap = 320;
              });

            },
            //----------------get latitutde and longtitude using the camera movement---------//
            onCameraMove: (CameraPosition camerapos)async {

              searching = false;
              setState(() {});
              finallat = camerapos.target.latitude.toString();
              finallong = camerapos.target.longitude.toString();
              String address2 = await AssistantMethod.nameCoordinatesAddress(camerapos, context);//passes the latlng using cameraposition to assistant method
              print("this is your Destination Address::" + address2);
            },
            //------------------------------------------------------------------------//
            onCameraIdle: () {
              searching = true;
              setState(() {});
            },
          ),
          //------------------MARKER-------------------/
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
              top: MediaQuery.of(context).size.height / 3.9,

              child: Image.asset(
                "images/markeruser.png",
                height: 80,
              ),
            ),
            ],
          ),
          searching == true
              ? Stack(
              alignment: Alignment.center,
                children: [
                  Positioned(
            top: MediaQuery.of(context).size.height / 5.3,

            child: Container(

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.white,
                ),
                width: 250,
                height: 43,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //-----coordinates--/////
                    // Text(
                    //   "Lat $finallat",
                    //   style: TextStyle(color: Colors.white),
                    // ),
                    // Text(
                    //   "Lng $finallong",
                    //   style: TextStyle(color: Colors.white),
                    // ),
                    //------------------/
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      child: Text(Provider.of<AppData>(context).destinationLocation!= null
                          ? Provider.of<AppData>(context).destinationLocation.placename
                          : "Destination", style: TextStyle(fontSize: 10, fontFamily: "bolt"),maxLines: 2,textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
            ),
          ),
              ])
              : Stack(
            alignment: Alignment.center,
                children: [
                  Positioned(
            top: MediaQuery.of(context).size.height / 6,

            child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 17.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.amber,
                ),
                width: 50,
                height: 40,
                child: Center(
                  child: SpinKitPulse(
                   color: Colors.white,
                    size: 20,
                  ),
                ),
            ),
          ),
              ]),
          //-------------------------------/
          // Positioned( DUMMY MARKER
          //   top: 170,
          //
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 175),
          //     child: FloatingActionButton(
          //       backgroundColor: Colors.transparent,
          //       child: Icon(Icons.location_on, color: Colors.amber, size: 40,),
          //     ),
          //   ),
          // ),

          // Positioned(
          //   top: 20,
          //   left: 22,
          //   child: Container(
          //     width: 85,
          //     height: 25,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.rectangle,
          //
          //
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(22),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black,
          //           blurRadius: 6,
          //           spreadRadius: .5,
          //           offset: Offset(
          //             .7,.7
          //           )
          //         )
          //       ]
          //     ),
          //     child: Row(
          //       children: [
          //         SizedBox(width: 4,),
          //         CircleAvatar(
          //           backgroundColor: Colors.white,
          //           child: Image.asset("images/PAZINGA.png", height: 20,width: 20,),
          //           radius: 10,
          //         ),
          //         SizedBox(width: 10,),
          //         Text("365.00")
          //       ],
          //     ),
          //   ),
          // ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: destinationContainer,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                boxShadow:[
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 20,
                    spreadRadius: .5,
                    offset: Offset(.7, .7),
                  )
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Fill in the Destination address", style: TextStyle(fontSize: 20, fontFamily: "bolt-bold"),),


                    SizedBox(height: 16.0,),

                    Row(
                      children: [
                        SizedBox(width: 12,),
                        Icon(Icons.location_on, color: Colors.amber,),
                        SizedBox(width: 12,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Provider.of<AppData>(context).destinationLocation!= null
                                ? Provider.of<AppData>(context).destinationLocation.placename
                                : "Destination", style: TextStyle(fontSize: 13,),maxLines: 2,
                            ),

                          ],

                        )

                      ],

                    ),
                    SizedBox(height: 10,),
                    DividerWidget(),
                    TextField(
                      controller: destinationAddress,
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                        prefixIcon:Icon(Icons.work, color: Colors.grey,),

                        labelText: "Landmark",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'bolt',
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    TextField(
                      controller: contactNumber,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixIcon:Icon(Icons.phone, color: Colors.grey,),

                        labelText: "Contact number",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'bolt',
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                        width: MediaQuery.of(context).size.width * .43,
                        child: RaisedButton(

                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          color: Colors.amber,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text('Confirm', style: TextStyle(
                                color: Colors.white,


                              ),

                              ),
                            ),
                          ),
                          onPressed: ()async{
                            print('PRESSED');
                            ////res = await Navigator.push(context, MaterialPageRoute(builder: (context)=> PaymentPanel())); temporary
                            Navigator.pop(context, "obtainDirection");
                            if(destinationAddress.text.length <= 15 || contactNumber.text == null){
                              displayToastMessage("address and contact number is not valid or too short", context);
                            }
                            else if(res == "obtainDirection"){
                              displayRideDetailsContainer();
                            }

                            else{
                              await getPlaceDirection();
                            }
                          },
                        ),
                      ),
                        Container(
                          width: MediaQuery.of(context).size.width * .43,
                          child: RaisedButton(

                            shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            color: Colors.red,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text('Cancel', style: TextStyle(
                                  color: Colors.white,


                                ),

                                ),
                              ),
                            ),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        ),
                   ] ),
                  ],

                ),
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: GestureDetector(
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                height: rideDetailsContainer,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                    boxShadow:[
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 16,
                        spreadRadius: .5,
                        offset: Offset(.7, .7),
                      )
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Review your Booking", style: TextStyle(fontSize: 20, fontFamily: "bolt-bold"),),


                      SizedBox(height: 16.0,),

                      Container(
                        width: double.infinity,
                        color:  Colors.amber,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(width: 12,),
                              Icon(Icons.bike_scooter),
                              SizedBox(width: 12,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Trike",style: TextStyle(fontFamily: "bolt",fontSize: 12),
                                  ),
                                  Text(((tripDirectionDetails != null)? tripDirectionDetails.distanceText : ''),style: TextStyle(fontFamily: "bolt",fontSize: 12),
                                  ),

                                ],

                              ),
                              Expanded(child: Container(),),
                              Text(((tripDirectionDetails != null)? '\PHP: ${AssistantMethod.calculateFares(tripDirectionDetails)}' : ''),style: TextStyle(fontFamily: "bolt",fontSize: 12),
                              )

                            ],

                          ),
                        ),
                      ),
                      SizedBox(height: 10,),

                      Container(
                        width: MediaQuery.of(context).size.width * .96,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5),

                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal:5,),
                          child: DropdownButton(

                            underline: SizedBox(),
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down_circle_outlined),
                            hint: Text("Select Payment",style: TextStyle(fontSize: 15, fontFamily: "bolt"),textAlign: TextAlign.center, ),
                            value: paymentChoose,
                            onChanged:(paymentValue){
                              setState(() {
                                paymentChoose = paymentValue;
                              });
                            },
                            items: payments.map((vehicleItem){
                              return DropdownMenuItem(

                                value: vehicleItem,
                                child: Text(vehicleItem,style: TextStyle(fontSize: 15, fontFamily: "bolt"),textAlign: TextAlign.center,),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      SizedBox(height: 10,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .43,
                              child: RaisedButton(

                                shape: new RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                color: Colors.amber,
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Text('Confirm', style: TextStyle(
                                      color: Colors.white,


                                    ),

                                    ),
                                  ),
                                ),
                                onPressed: ()async{

                                  print('PRESSED');
                                  setState(() {
                                    destinationContainer =0;
                                    loadingRider = 280;
                                  });
                                },
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .43,
                              child: RaisedButton(

                                shape: new RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                color: Colors.red,
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Text('Cancel', style: TextStyle(
                                      color: Colors.white,


                                    ),

                                    ),
                                  ),
                                ),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ] ),
                    ],

                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: GestureDetector(
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                height: loadingRider,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                    boxShadow:[
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 16,
                        spreadRadius: .5,
                        offset: Offset(.7, .7),
                      )
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Text("Please wait...", style: TextStyle(fontSize: 20, fontFamily: "bolt-bold"),)),





                      SizedBox(height: 60,),

                      Center(
                          child: GestureDetector(
                            onTap: cancelSearch,
                          child: SpinKitPulse(
                            color: Colors.amber,
                            size: 50,

                          )
                      )
                      ),




                    ],

                  ),
                ),
              ),
            ),
          ),
        ],

      ),

    );
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

}
displayToastMessage(String Message, BuildContext context){
  Fluttertoast.showToast(msg: Message);
}
