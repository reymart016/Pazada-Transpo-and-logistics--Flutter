import 'package:flutter/foundation.dart';
import 'package:pazada/Config/config.dart';

class CartItemCounter extends ChangeNotifier
{
  int _counter = PazabuyApp.sharedPreferences.getStringList(PazabuyApp.userCartList).length-1;
  int get count => _counter;

  Future<void> displayResult() async
  {
    int _counter = PazabuyApp.sharedPreferences.getStringList(PazabuyApp.userCartList).length-1;

    await Future.delayed(const Duration(milliseconds: 100), (){
      notifyListeners();
    });
  }
}