import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pazada/widgets/login/login_screen.dart';
import 'package:pazada/widgets/shared/divider.dart';
import 'package:pazada/widgets/signup/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PazadaScreen extends StatefulWidget {
  static const String idScreen = "pazadaScreen";

  @override
  _PazadaScreenState createState() => _PazadaScreenState();
}

class _PazadaScreenState extends State<PazadaScreen> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

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
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller){
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
            },
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: 320.0,
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
                    Container(
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
                    SizedBox(height:24),
                    Row(
                      children: [
                        Icon(Icons.home, color: Colors.grey,),
                        SizedBox(width: 12,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Add Home"),
                            SizedBox(height: 4,),
                            Text("Your Living Home Address", style: TextStyle(color: Colors.grey, fontSize: 12),)
                          ],
                        )
                      ],
                    ),
                    SizedBox(height:10),
                    DividerWidget(),
                    SizedBox(height: 16.0,),
                    Row(
                      children: [
                        Icon(Icons.work, color: Colors.grey,),
                        SizedBox(width: 12,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Add Office"),
                            SizedBox(height: 4,),
                            Text("Your Office Address", style: TextStyle(color: Colors.grey, fontSize: 12),)
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
