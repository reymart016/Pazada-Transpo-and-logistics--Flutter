import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pazada/assistants/assistantMethod.dart';
import 'package:pazada/dataHandler/appData.dart';
import 'package:pazada/widgets/dropOff_screen/dropOff_screen.dart';
import 'package:pazada/widgets/login/login_screen.dart';
import 'package:pazada/widgets/shared/divider.dart';
import 'package:pazada/widgets/signup/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class PazadaScreen extends StatefulWidget {
  static const String idScreen = "pazadaScreen";

  @override
  _PazadaScreenState createState() => _PazadaScreenState();
}

class _PazadaScreenState extends State<PazadaScreen> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingofMap = 0;
  void locatePosition()async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));


    String address = await AssistantMethod.searchCoordinatesAddress(position, context);
    print("this is your Address::" + address);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Pazada", style: TextStyle( color: Colors.white),),
      ),
      backgroundColor: Colors.white,
      drawer: Container(

        color: Colors.white,
        width: 255,
        child: Drawer(


          child: ListView(
            children: [
              Container(
                height: 165,
                child: DrawerHeader(

                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(

                    children: [
                      Image.asset("images/pazada-logo.png", height: 65,width: 65,),
                      SizedBox(width: 116,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 16,),
                      Text("Profile Name", style: TextStyle(fontFamily: "bolt-bold", fontSize: 15),),
                      SizedBox(height: 12,),
                      Text("Visit Profile", style: TextStyle(fontFamily: "bolt", fontSize: 12),),

                         ],

                      ),

                    ],

                  ),
                ),
              ),

              DividerWidget(),
              SizedBox(height: 12,),
              ListTile(
                leading: Icon(Icons.history),
                title: Text("History", style: TextStyle(fontSize: 15, fontFamily: "bolt"),),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Visit Profile", style: TextStyle(fontSize: 15, fontFamily: "bolt"),),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("About", style: TextStyle(fontSize: 15, fontFamily: "bolt"),),
              ),
              ListTile(
                leading: Icon(Icons.bug_report),
                title: Text("Report Bugs", style: TextStyle(fontSize: 15, fontFamily: "bolt"),),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingofMap),
            mapType: MapType.normal,
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
                            Text("Add Office"),
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
          )
        ],
      )
    );
  }
}
