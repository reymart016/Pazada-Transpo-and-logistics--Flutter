import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pazada/Config/config.dart';
import 'package:pazada/assistants/pazabuy/pazabuy.dart';
import 'package:pazada/bottomBar/bottomAppBar.dart';
import 'package:pazada/configs/MapsConfig.dart';
import 'package:pazada/widgets/idle_screen/idle_screen.dart';
import 'package:pazada/widgets/login/login_screen.dart';
import 'package:pazada/widgets/pazabuy_screen/pazabuy_screen.dart';
import 'package:pazada/widgets/pazada_screen.dart';
import 'package:pazada/widgets/pazakay/pazakay_payment.dart';
import 'package:pazada/widgets/shared/TNC.dart';
import 'package:pazada/widgets/shared/bottomNavigationBar.dart';
import 'package:pazada/widgets/shared/driverInfo.dart';
import 'package:pazada/widgets/shared/screenState.dart';
import 'package:pazada/widgets/signup/signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Counters/ItemQuantity.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'assistants/assistantMethod.dart';
import 'dataHandler/appData.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  AssistantMethod.getCurrentOnlineInformation();
  await Firebase.initializeApp();
  PazabuyApp.sharedPreferences = await  SharedPreferences.getInstance();
  PazabuyApp.firestore = FirebaseFirestore.instance;
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
    return MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (context)=> AppData(),),
        ChangeNotifierProvider(create: (context) => CartItemCounter()),
        ChangeNotifierProvider(create: (context) => ItemQuantity()),
        ChangeNotifierProvider(create: (context) => AddressChanger()),
        ChangeNotifierProvider(create: (context) => TotalAmount()),
      ],

      child: MaterialApp(
        title: 'Pazada',
        theme: ThemeData(

          primarySwatch: Colors.amber,

          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

        initialRoute: FirebaseAuth.instance.currentUser == null ? LoginScreen.idScreen : BottomBar.idScreen,
        routes: {
          PazabuyScreen.idScreen: (context) => PazabuyScreen(),
          BottomNavBar.idScreen: (context) => BottomNavBar(),
          BottomBar.idScreen: (context) => BottomBar(),
          IdleScreen.idScreen: (context) => IdleScreen(),
          SignupScreen.idScreen: (context) => SignupScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          PazadaScreen.idScreen: (context) => PazadaScreen(),
          ScreenStatus.idScreen: (context) => ScreenStatus(),
          PazakayPayment.idScreen: (context) => PazakayPayment(),
          DriverInfo.idScreen: (context) => DriverInfo(),
          TermsAndCondition.idScreen: (context) => TermsAndCondition()
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

