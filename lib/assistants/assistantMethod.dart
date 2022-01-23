import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pazada/assistants/pazabuy/cart_item_counter.dart';

import 'package:pazada/assistants/requestAssistants.dart';
import 'package:pazada/configs/MapsConfig.dart';
import 'package:pazada/configs/Universal_Variable.dart';
import 'package:pazada/dataHandler/appData.dart';
import 'package:pazada/main.dart';
import 'package:pazada/models/address.dart';
import 'package:pazada/models/allUsers.dart';
import 'package:pazada/models/directionDetails.dart';
import 'package:pazada/widgets/pazabuy_screen/pazabuy_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart'as http;


class AssistantMethod{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static Future<String> searchCoordinatesAddress(Position position, context)async{
    String placeAddress = "";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    var response = await RequestAssistant.getRequest(url);

    if(response!= "failed"){
      placeAddress = response["results"][0]["formatted_address"];

      Address userPickUpAddress = new Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placename = placeAddress;

      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }
    return placeAddress;
  }

  //-------------DESTINATION REVERSE GEOCODING---/////
  static Future<String> nameCoordinatesAddress(CameraPosition camerapos, context)async{
    String placeAddress = "";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${camerapos.target.latitude},${camerapos.target.longitude}&key=$mapKey";
    var response = await RequestAssistant.getRequest(url);

    if(response!= "failed"){
      placeAddress = response["results"][0]["formatted_address"];

      Address desuserPickUpAddress = new Address();
      desuserPickUpAddress.longitude = camerapos.target.longitude;
      desuserPickUpAddress.latitude = camerapos.target.latitude;
      desuserPickUpAddress.placename = placeAddress;

      Provider.of<AppData>(context, listen: false).updateDestinationAddress(desuserPickUpAddress);
    }
    return placeAddress;
  }


  static Future <DirectionDetails> obtainPlaceDirectionDetails(LatLng initialLocation, LatLng finalPosition)async{

    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialLocation.latitude},${initialLocation.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";

    var res = await RequestAssistant.getRequest(directionUrl);

    if(res == "failed"){
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints = res["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];
    directionDetails.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.durationText = res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue = res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }
  static int calculateFares(DirectionDetails directionDetails){
    double timeTraveledFare = (directionDetails.durationValue / 60)* 0.20;
    double distanceTraveledFare = (directionDetails.distanceValue / 1000)* 0.20;
    double totalFareAmount = timeTraveledFare + distanceTraveledFare;
    double localFare = totalFareAmount *  50;
    return localFare.truncate();

  }

  static void getCurrentOnlineInformation()async{


    firebaseUser =await FirebaseAuth.instance.currentUser;
    userId = firebaseUser.uid; // get the uid of the current user
    DatabaseReference reference = FirebaseDatabase.instance.reference().child('PazadaUsers').child(userId);
    print("============================");
    print(userId);
    print("============================");
    reference.once().then((DataSnapshot dataSnapShot)
    {
      if(dataSnapShot.value != null){
        usersCurrentInfo = Users.fromSnapshot(dataSnapShot);// access to User models
      }
    }
    );
  }
  static double createRandomNumber(int num){
    var random = Random();
    int randomNumber = random.nextInt(num);
    return randomNumber.toDouble();

  }

  static Future<String> nameCoordinatesAddress2(CameraPosition camerapos2, context)async{
    String placeAddress = "";
    String st1, st2, st3,st4;
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${camerapos2.target.latitude},${camerapos2.target.longitude}&key=$mapKey";
    var response = await RequestAssistant.getRequest(url);

    if(response!= "failed"){
      placeAddress = response["results"][0]["formatted_address"];
      // st1 = response["results"][0]["address_components"][0]["long_name"];
      // st2 = response["results"][0]["address_components"][4]["long_name"];
      // st3 = response["results"][0]["address_components"][5]["long_name"];
      // st4 = response["results"][0]["address_components"][6]["long_name"];
      // placeAddress = st1 + ", " + st2 + ", " + st3 + ", " + st4;
      Address desuserPickUpAddress2 = new Address();
      desuserPickUpAddress2.longitude = camerapos2.target.longitude;
      desuserPickUpAddress2.latitude = camerapos2.target.latitude;
      desuserPickUpAddress2.placename = placeAddress;

      Provider.of<AppData>(context, listen: false).updateDestinationAddress2(desuserPickUpAddress2);
    }
    return placeAddress;
  }
  void locatePosition()async{
    Completer<GoogleMapController> _controllerGoogleMap = Completer();
    GoogleMapController newGoogleMapController;
    var geoLocator = Geolocator();
    Position currentPosition,desPosition;


    Position position =await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new CameraPosition(target: latLngPosition, zoom: 16);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    print("POSITION::$currentPosition");
    //String address = await AssistantMethod.searchCoordinatesAddress(position, context);
    //print("this is your Address::" + address);
    //initGeofireListener();

  }

  static void retrieveUserData(context){
    usersRef.child(currentfirebaseUser.uid).once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot != null){
        String currentUsername = dataSnapshot.value.toString();


      }
    });
  }

  static sendNotificationToDriver(String token, context, String ride_request_id)async{
    String url = 'https://fcm.googleapis.com/fcm/send';
    var finalDestination;
    var destinationA = Provider.of<AppData>(context, listen: false).destinationLocation;
    var destinationB = Provider.of<AppData>(context, listen: false).destinationLocation2;
    if(destinationA != null){
      finalDestination = destinationA.placename;
    }else{
      finalDestination = destinationB.placename;

    }

    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverToken,
    };

    Map notificationMap = {
      'body': 'Destination Address, ${finalDestination}',
      'title': 'New Pazada Request Nearby',
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'ride_request_id': ride_request_id,
    };

    Map sendNotificationMap = {
      "notification": notificationMap,
      "data": dataMap,
      "priority": "high",
      "to": token,
    };
    var res = await http.post(
      Uri.parse(url),
      headers: headerMap,
      body: jsonEncode(sendNotificationMap),
    );
  }
  static sendPazabuyNotificationToDriver(String token, context, String ride_request_id)async{
    String url = 'https://fcm.googleapis.com/fcm/send';
    var finalDestination;
    var destinationA = Provider.of<AppData>(context, listen: false).destinationLocation;
    var destinationB = Provider.of<AppData>(context, listen: false).destinationLocation2;
    if(destinationA != null){
      finalDestination = destinationA.placename;
    }else{
      finalDestination = destinationB.placename;

    }

    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverToken,
    };

    Map notificationMap = {
      'body': 'Destination Address, ${finalDestination}',
      'title': 'New Pazabuy Request Nearby',
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'ride_request_id': ride_request_id,
    };

    Map sendNotificationMap = {
      "notification": notificationMap,
      "data": dataMap,
      "priority": "high",
      "to": token,
    };
    var res = await http.post(
      Uri.parse(url),
      headers: headerMap,
      body: jsonEncode(sendNotificationMap),
    );
  }


  Future<String> getCurrentUID() async {
    return await _firebaseAuth.currentUser.uid;
  }













}

addItemToCart(String foodItemId, BuildContext context, int itemCounter)
{
  List<String> tempList = sharedPreferences.getStringList("userCart");
  tempList.add(foodItemId + ":$itemCounter"); //56557657:7

  FirebaseFirestore.instance.collection("PazadaUsers")
      .doc(firebaseUser.uid).update({
    "userCart": tempList,
  }).then((value)
  {
    Fluttertoast.showToast(msg: "Item Added successfully.");

    sharedPreferences.setStringList("userCart", tempList);

    Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();
  });
}
separateItemIDs()
{
  List<String> separateItemsIDsList=[], defaultItemList=[];
  int i=0;

  defaultItemList = sharedPreferences.getStringList("userCart");

  for(i; i<defaultItemList.length; i++)
  {
    String item =  defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    print("\nThis is ItemId now = " + getItemId);

    separateItemsIDsList.add(getItemId);
  }
  print("\nThis is Items List now = ");
  print(separateItemsIDsList);

  return separateItemsIDsList;
}
clearCartNow(context)
{
  sharedPreferences.setStringList("userCart", ['garbageValue']);
  List<String> emptyList = sharedPreferences.getStringList("userCart");

  FirebaseFirestore.instance.collection("PazadaUsers")
      .doc(currentfirebaseUser.uid)
      .update({"userCart": emptyList}).then((value)
  {
    sharedPreferences.setStringList("userCart", emptyList);
    Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();


  });
}
separateItemQuantities(){
  List<int> separateItemQuantityList=[];
  List<String> defaultItemList = [];
  int i = 1;
  defaultItemList = sharedPreferences.getStringList("userCart");
for(i; i<defaultItemList.length; i++)
{
String item =  defaultItemList[i].toString();
List<String>listItemCharacters = item.split(":").toList();
var quanNumber = int.parse(listItemCharacters[1].toString());
print("\nThis is Quantity NUmber = " + quanNumber.toString());

separateItemQuantityList.add(quanNumber);
}
print("\nThis is Items List now = ");
print(separateItemQuantityList);

return separateItemQuantityList;
}