
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pazada/configs/MapsConfig.dart';
import 'package:pazada/models/nearbyAvalableDrivers.dart';
import 'package:shared_preferences/shared_preferences.dart';



String token = "";
String state = "normal";

String serverToken = "key=AAAA8vgZhqg:APA91bGM0qMEDNFOtFx0uDKoaIz-EmojVi-VsZhWePrXYUIqi2-58fZ1OMElknWYC3BwNqfn6NP6bbdgEMLlDrqblnoDhEPKvum9H9IF-RbouyhKFp1ec0FKXUTPtcKG-Nwk1oYEqQdM";

DatabaseReference pazShipRef = FirebaseDatabase.instance.reference().child("PazShip_Booking");
DatabaseReference rideRequestRef;
String keyy= "";
String qrCodeResult = "";
String numm = "";
bool cancelBtn = true;
bool scanBtn = false;
int counter = 30;

int driveRequesttimeOut = 40;
String driverID = "";
String rideStatus ="";
bool rideType = false;
String qrData = "";
String qrData2 = "";
String username ="";
int size = 0;
String usernamee = "";
String uid = "";
int fareMatrixValue = 0;
int fareValue = 0;
int fareKM = 0;
int kmData = 0;
DocumentSnapshot snapshot;
var faretotal;
String profileName = "";
String userName="";
int number = 0;
String driver_phone = "";
String driver_name = "";
String email = "";
String vehicle_color = "";
String itemCount = "12";
String vehicle_model = "";
String vehicle_plateNum = "";
String vehicle_type = "";
String vehicle_details = "";
SharedPreferences sharedPreferences;
int UserKart;
String price = "";
String item_value ="";

String pointA = "";
String pointB = "";
String randomID = "";
String pazadaDriverID = "";
String review = "";
String sellerUID = "";
String staticLocation = "";

StreamSubscription<Event> rideStreamSubscription;
StreamSubscription<Event> rideStreamSubscriptionB;
bool enabled = false;

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

double finalDestination = 0;
double rideDetailsContainer = 0;
double destinationContainer = 280;
double loadingRider = 0;

String userID = "";
String userEmail = "";
String userImageUrl = "";
String getUserName = "";

String adUserName = "";
String adUserImageUrl = "";
int quantity = 1;
String sellername = "";
String sellerid = "";
String sellerphone ="";

String completeAddress = "";
User user = FirebaseAuth.instance.currentUser;

double average = 0;
double total = 0;
double tempPrice = 49;
String rideKey = "";

bool isVerified = false;
bool ispazShip = false;