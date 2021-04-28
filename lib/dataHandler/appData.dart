import 'package:flutter/cupertino.dart';
import 'package:pazada/models/address.dart';

class AppData extends ChangeNotifier{

      Address pickUpLocation;
      Address destinationLocation;
      void updatePickUpLocationAddress(Address pickUpAddress){
        pickUpLocation = pickUpAddress;
        notifyListeners();
      }
      void updateDestinationAddress(Address destinationAddress){
        destinationLocation = destinationAddress;
        notifyListeners();
      }

}