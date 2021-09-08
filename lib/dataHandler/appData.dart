import 'package:flutter/cupertino.dart';
import 'package:pazada/models/address.dart';
import 'package:pazada/models/allUsers.dart';

class AppData extends ChangeNotifier{

      Address pickUpLocation;
      Address destinationLocation;
      Address destinationLocation2;
      Users userName;
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
      void updateUserName(Users username){
        userName = username;
        notifyListeners();
      }

}