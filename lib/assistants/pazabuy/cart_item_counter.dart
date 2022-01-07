import 'package:flutter/cupertino.dart';
import 'package:pazada/configs/Universal_Variable.dart';

class CartItemCounter extends ChangeNotifier
{
    int cartListItemCounter = sharedPreferences.getStringList("userCarts").length-1;
    int get count => cartListItemCounter;

    Future<void> displayCartListItemNumber() async
    {
        cartListItemCounter = sharedPreferences.getStringList("userCarts").length -1;

        await Future.delayed(const Duration(milliseconds: 100), () {
             notifyListeners();
        }); //Future.delayed
    }
}  