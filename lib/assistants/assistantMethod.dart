import 'package:geolocator/geolocator.dart';
import 'package:pazada/assistants/requestAssistants.dart';
import 'package:pazada/configs/MapsConfig.dart';
import 'package:pazada/dataHandler/appData.dart';
import 'package:pazada/models/address.dart';
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
}