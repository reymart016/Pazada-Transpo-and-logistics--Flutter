import 'package:flutter/cupertino.dart';
import 'package:pazada/models/address.dart';

class AppData extends ChangeNotifier{

      Address pickUpLocation;
      Address destinationLocation;
      Address destinationLocation2;
      void updatePickUpLocationAddress(Address pickUpAddress){
        pickUpLocation = pickUpAddress;
        notifyListeners();
      }
      void updateDestinationAddress(Address destinationAddress){
        destinationLocation = destinationAddress;
        notifyListeners();
      }
      void updateDestinationAddress2(Address destinationAddress2){
        destinationLocation2 = destinationAddress2;
        notifyListeners();
      }

}