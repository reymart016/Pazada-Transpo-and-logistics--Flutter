import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pazada/bottomBar/bottomAppBar.dart';
import 'package:pazada/configs/MapsConfig.dart';
import 'package:pazada/widgets/idle_screen/idle_screen.dart';
import 'package:pazada/widgets/login/login_screen.dart';
import 'package:pazada/widgets/pazada_screen.dart';
import 'package:pazada/widgets/pazakay/pazakay_payment.dart';
import 'package:pazada/widgets/shared/bottomNavigationBar.dart';
import 'package:pazada/widgets/shared/driverInfo.dart';
import 'package:pazada/widgets/shared/screenState.dart';
import 'package:pazada/widgets/signup/signup_screen.dart';
import 'package:provider/provider.dart';

import 'dataHandler/appData.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
  DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("PazadaUsers");
  DatabaseReference driversRef = FirebaseDatabase.instance.reference().child("PazadaDrivers");
  DatabaseReference newRequestRef = FirebaseDatabase.instance.reference().child("Ride_Request");
  //DatabaseReference rideRequestRef = FirebaseDatabase.instance.reference().child("PazadaDrivers").child(currentfirebaseUser.uid).child("newRide");

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> AppData(),
      child: MaterialApp(
        title: 'Pazada',
        theme: ThemeData(

          primarySwatch: Colors.amber,

          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: FirebaseAuth.instance.currentUser == null ? LoginScreen.idScreen : BottomBar.idScreen,
        routes: {
          BottomNavBar.idScreen: (context) => BottomNavBar(),
          BottomBar.idScreen: (context) => BottomBar(),
          IdleScreen.idScreen: (context) => IdleScreen(),
          SignupScreen.idScreen: (context) => SignupScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          PazadaScreen.idScreen: (context) => PazadaScreen(),
          ScreenStatus.idScreen: (context) => ScreenStatus(),
          PazakayPayment.idScreen: (context) => PazakayPayment(),
          DriverInfo.idScreen: (context) => DriverInfo()
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

