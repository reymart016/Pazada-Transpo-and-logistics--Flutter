import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pazada/assistants/assistantMethod.dart';
import 'package:pazada/dataHandler/appData.dart';
import 'package:pazada/widgets/dropOff_screen/dropOff_screen.dart';
import 'package:pazada/widgets/login/login_screen.dart';
import 'package:pazada/widgets/shared/divider.dart';
import 'package:pazada/widgets/shared/navbar.dart';
import 'package:pazada/widgets/signup/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as lct;


class PazadaScreen extends StatefulWidget {
  static const String idScreen = "pazadaScreen";


  @override
  _PazadaScreenState createState() => _PazadaScreenState();
}

class _PazadaScreenState extends State<PazadaScreen> {

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;
  List<Marker> _markers = [];
  String finallat = "";
  String finallong = "";
  double FinalLat, FinalLong;
  bool searching = false;
  lct.Location location;
  String coordinates = "";

  Position currentPosition,desPosition;

  var geoLocator = Geolocator();
  double bottomPaddingofMap = 0;
  void locatePosition()async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    currentPosition = position;
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new CameraPosition(target: latLngPosition, zoom: 16);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    print("POSITION::$currentPosition");
    String address = await AssistantMethod.searchCoordinatesAddress(position, context);
    print("this is your Address::" + address);

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

    return Scaffold(

      body: Stack(
        children: [

          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingofMap),
            mapType: MapType.hybrid,
              // onTap: _onAddMarkerButton,
              markers: Set.from(_markers),
              myLocationButtonEnabled: true,

              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
               zoomControlsEnabled: true,

            onMapCreated: (GoogleMapController controller){
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              locatePosition();
              setState(() {
                bottomPaddingofMap = 300;
              });
            },
            //----------------get latitutde and longtitude using the camera movement---------//
            onCameraMove: (CameraPosition camerapos)async {
              searching = false;
              setState(() {});
              finallat = camerapos.target.latitude.toString();
              finallong = camerapos.target.longitude.toString();
              String address2 = await AssistantMethod.nameCoordinatesAddress(camerapos, context);//passes the latlng using cameraposition to assistant method
              print("this is your Address::" + address2);
            },
            //------------------------------------------------------------------------//
            onCameraIdle: () {
              searching = true;
              setState(() {});
            },
          ),
          //------------------MARKER-------------------/
          Positioned(
            top: MediaQuery.of(context).size.height / 3.6,
            left: MediaQuery.of(context).size.width / 2.38,
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                "images/markeruser.png",
                height: 80,
              ),
            ),
          ),
          searching == true
              ? Positioned(
            top: MediaQuery.of(context).size.height / 4.5,
            left: MediaQuery.of(context).size.width / 4.2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white,
              ),
              width: 180,
              height: 40,
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
                    padding: const EdgeInsets.all(8.0),
                    child: Text(Provider.of<AppData>(context).destinationLocation!= null
                        ? Provider.of<AppData>(context).destinationLocation.placename
                        : "Destination", style: TextStyle(fontSize: 10,),maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          )
              : Positioned(
            top: MediaQuery.of(context).size.height / 3.1,
            left: MediaQuery.of(context).size.width / 2.3,
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 17.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.black.withOpacity(0.75),
              ),
              width: 50,
              height: 40,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 2.5,
                ),
              ),
            ),
          ),
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

          Positioned(
            top: 20,
            left: 22,
            child: Container(
              width: 85,
              height: 25,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,


                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 6,
                    spreadRadius: .5,
                    offset: Offset(
                      .7,.7
                    )
                  )
                ]
              ),
              child: Row(
                children: [
                  SizedBox(width: 4,),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image.asset("images/PAZINGA.png", height: 20,width: 20,),
                    radius: 10,
                  ),
                  SizedBox(width: 10,),
                  Text("365.00")
                ],
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: 300.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
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
                    Text("Hi, there", style: TextStyle(fontSize: 12),),
                    Text("Where to", style: TextStyle(fontSize: 20, fontFamily: "bolt-bold"),),
                    SizedBox(height: 20,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> DropOff()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 6,
                              spreadRadius: .5,
                              offset: Offset(.7, .7),
                            )

                          ]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.amberAccent,),
                              SizedBox(width: 10,),
                              Text("Search Drop Off")
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height:24),
                    Row(
                      children: [
                        Icon(Icons.location_on_sharp, color: Colors.red,),
                        SizedBox(width: 12,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Provider.of<AppData>(context).pickUpLocation!= null
                            ? Provider.of<AppData>(context).pickUpLocation.placename
                                : "Add Home", style: TextStyle(fontSize: 10,),maxLines: 2,
                            ),
                            SizedBox(height: 4,),
                            Text("Current Location", style: TextStyle(color: Colors.amber, fontSize: 12),)
                          ],
                        )
                      ],
                    ),
                    SizedBox(height:10),
                    DividerWidget(),
                    SizedBox(height: 16.0,),
                    Row(
                      children: [
                        Icon(Icons.work, color: Colors.blue,),
                        SizedBox(width: 12,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Provider.of<AppData>(context).destinationLocation!= null
                                ? Provider.of<AppData>(context).destinationLocation.placename
                                : "Destination", style: TextStyle(fontSize: 10,),maxLines: 2,
                            ),
                            SizedBox(height: 4,),
                            Text("Your Office Address", style: TextStyle(color: Colors.amber, fontSize: 12),)
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          // Padding(padding: EdgeInsets.all(10),
          //   child: Row(
          //     children: [
          //       button(_onAddMarkerButton, Icons.add_location_alt_outlined)
          //     ],
          //   ),
          //
          // )
        ],

      ),

    );
  }
}
