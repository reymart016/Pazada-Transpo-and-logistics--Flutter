
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:pazada/configs/MapsConfig.dart';
import 'package:pazada/models/nearbyAvalableDrivers.dart';



String token = "";
String state = "normal";

String serverToken = "key=AAAA8vgZhqg:APA91bGM0qMEDNFOtFx0uDKoaIz-EmojVi-VsZhWePrXYUIqi2-58fZ1OMElknWYC3BwNqfn6NP6bbdgEMLlDrqblnoDhEPKvum9H9IF-RbouyhKFp1ec0FKXUTPtcKG-Nwk1oYEqQdM";

DatabaseReference pazShipRef = FirebaseDatabase.instance.reference().child("PazShip_Booking");
DatabaseReference rideRequestRef;
String keyy= "";
String qrCodeResult = "";
String num = "";
bool cancelBtn = true;
bool scanBtn = false;
int counter = 30;

int driveRequesttimeOut = 40;
String driverID = "";
String rideStatus ="";
String username ="";
String userName="";
String number = "";
String driver_phone = "";
String email = "";
String vehicle_color = "";
String vehicle_model = "";
String vehicle_plateNum = "";
String vehicle_type = "";
String vehicle_details = "";

StreamSubscription<Event> rideStreamSubscription;

double starCounter = 0.0;
String rateTitle = " ";

String rideRequestId = ''; //current ID of the ride
String pickupLocationText = "";
String destinationLocationText = "";
String fareText = "";
int rideHistoryTotal = 0;

List rideHistoryy = [];
bool isvisible = false;

String testest = "test";