import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pazada/assistants/requestAssistants.dart';
import 'package:pazada/configs/MapsConfig.dart';
import 'package:pazada/dataHandler/appData.dart';
import 'package:pazada/models/address.dart';
import 'package:pazada/models/directionDetails.dart';
import 'package:provider/provider.dart';

class AssistantMethod{
  static Future<String> searchCoordinatesAddress(Position position, context)async{
    String placeAddress = "";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    var response = await RequestAssistant.getRequest(url);

    if(response!= "failed"){
      placeAddress = response["results"][0]["formatted_address"];

      Address userPickUpAddress = new Address();
      userPickUpAddress.longtitude = position.longitude;
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
      desuserPickUpAddress.longtitude = camerapos.target.longitude;
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
}