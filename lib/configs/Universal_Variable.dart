
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:pazada/configs/MapsConfig.dart';
import 'package:pazada/models/nearbyAvalableDrivers.dart';



String token = "";
String state = "normal";

String serverToken = "key=AAAA8vgZhqg:APA91bGM0qMEDNFOtFx0uDKoaIz-EmojVi-VsZhWePrXYUIqi2-58fZ1OMElknWYC3BwNqfn6NP6bbdgEMLlDrqblnoDhEPKvum9H9IF-RbouyhKFp1ec0FKXUTPtcKG-Nwk1oYEqQdM";

DatabaseReference pazShipRef = FirebaseDatabase.instance.reference().child("PazShip_Booking");

int driveRequesttimeOut = 40;

String rideStatus ="";
String username ="";
String number = "";
String driver_phone = "";
String email = "";
String vehicle_color = "";
String vehicle_model = "";
String vehicle_plateNum = "";
String vehicle_type = "";
String vehicle_details = "";

StreamSubscription<Event> rideStreamSubscription;



