import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:pazada/assistants/assistantMethod.dart';
import 'package:pazada/configs/MapsConfig.dart';
import 'package:pazada/configs/Universal_Variable.dart';
import 'package:pazada/dataHandler/appData.dart';
import 'package:pazada/main.dart';
import 'package:pazada/models/allUsers.dart';
import 'package:pazada/models/pazabuyusers.dart';
import 'package:pazada/user_dashboard/PazadaCard.dart';
import 'package:pazada/user_dashboard/color.dart';
import 'package:pazada/user_dashboard/layout.dart';
import 'package:pazada/widgets/pazabuy_screen/pazabuy_item_list.dart';
import 'package:pazada/widgets/pazabuy_screen/pazabuy_screen.dart';

import 'package:pazada/widgets/pazada_screen.dart';
import 'package:pazada/widgets/pazada_screen/payment_panel.dart';
import 'package:pazada/widgets/pazakay/mode2/pazakay_query2.dart';
import 'package:pazada/widgets/pazakay/pazakay_query.dart';
import 'package:pazada/widgets/pazship/pazship_query.dart';
import 'package:provider/provider.dart';


class IdleScreen extends StatefulWidget {
  PazabuyUsers models;
  IdleScreen({this.models});
  static const String idScreen = "idleScreen";
  @override
  _IdleScreenState createState() => _IdleScreenState();
}

class _IdleScreenState extends State<IdleScreen> {
 AssistantMethod assistantMethod = AssistantMethod();
 DatabaseReference usersReff = FirebaseDatabase.instance.reference().child("PazadaUsers");
 final auth = FirebaseAuth.instance;
Timer timer;

  @override
  void initState() {

   timer = Timer.periodic(Duration(seconds: 1), (timer){
     checkEmailVerified();
     print(timer);
    });

    // TODO: implement initState
    super.initState();
    Users currentUserInfo;
    //retrieveUserData();
    print(userId);
    AssistantMethod.getCurrentOnlineInformation();
    setState(() {
      username = username;

    });
   print("USERNAME::"+ username);
    getProfileDetails();
  }
  Future<void> checkEmailVerified()async{
    user = auth.currentUser;
    await user.reload();
    if(user.emailVerified){
      setState(() {
        isVerified = true;
        timer.cancel();
      });
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(

        children: [

          Stack(
          children: [

          Container(
          height: 230,
          alignment: Alignment.center,

          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(10),

          ),
            child: Column(
              children: [
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.only(top: 8,left: 8,right: 12,),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Expanded(child: Text("Hello \n" + username,style: TextStyle(fontSize: 30, fontFamily: "bolt-bold", color: Colors.white) ,maxLines: 2, )),

                        Icon(Icons.notifications_active, color: Colors.white, size: 30,),

                      ],
                    ),
                  ),
                )
              ],
            ),
        ),
            Positioned(

              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 70,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * .80,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(
                          color: Colors.grey,
                          blurRadius: 6,
                          spreadRadius: .5,
                          offset: Offset(1,7)
                      )]
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SizedBox(height: 10,),
                                Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Text("Total Trips",style: TextStyle(fontSize: 20, fontFamily: "bolt-bold", color: Colors.black) ,maxLines: 3,textAlign: TextAlign.center,  ),
                                  Text(rideHistoryTotal.toString(),style: TextStyle(fontSize: 20, fontFamily: "bolt-bold", color: Colors.black) ,maxLines: 3,textAlign: TextAlign.center,  ),
                                ],
                              ),
                         ] ),
                          ),

                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),


          ],
        ),
          SizedBox(height: 10,),
          Container(
            child: Text("Choose your desired Service",style: TextStyle(fontSize: 20, fontFamily: "bolt-bold", color: Colors.black) ,maxLines: 2, ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:8.0, right: 8, bottom: 8, top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                SizedBox(height: spacing),
                GestureDetector(
                  onTap: (){
                    showDialog(context: context, builder: (context)=>AlertDialog(
                      title: Text("Choose Service"),
                      content: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: services3,
                              child: Container(
                                height: 100,
                                alignment: Alignment.center,

                                width: MediaQuery.of(context).size.width/4,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset('images/svg/trikeA.svg', height: 60,),
                                      Text('Book Now', style: TextStyle(fontFamily: "bolt",fontSize: 11, color: Colors.white),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: services4,
                              child: Container(
                                height: 100,
                                alignment: Alignment.center,

                                width: MediaQuery.of(context).size.width/4,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset('images/svg/man.svg', height: 60,),
                                      SizedBox(height: 2,),
                                      Text('Book for Someone', style: TextStyle(fontFamily: "bolt",fontSize: 10, color: Colors.white),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [

                      ],
                    ));
                  },
                  child: PazadaCard(
                    color: pazakay,
                    label: "Pazakay",
                    svgPath: 'images/svg/Artboard 4.svg',
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    if(user.emailVerified){
                      services2();
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Verify your account to unlock Pazabuy.", style:
                        TextStyle(fontSize: 18.0, color: Colors.amber, fontFamily: 'bolt-bold')
                        ,)));
                    }
                  },
                  child: PazadaCard(
                    color: pazabuy,
                    label: "Pazabuy",
                    svgPath: 'images/svg/pazabuy.svg',
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    if(user.emailVerified){
                      pazshipQuery();
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Verify your account to unlock PazShip.", style:
                        TextStyle(fontSize: 18.0, color: Colors.amber, fontFamily: 'bolt-bold')
                        ,)));
                    }
                  },
                  child: PazadaCard(
                    color: pazship,
                    label: "PazShip",
                    svgPath: 'images/svg/sidetric.svg',
                  ),
                ),
              ],
            ),
          )
    ]
      ),
    );
  }
  void services (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> PazadaScreen()));
  }
  void services2 (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> PazabuyScreen()));
  }
  void services3 (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> PazakayQuery()));
  }
  void services4 (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> PazakayQuery2()));
  }
  void pazshipQuery (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> PazShipQuery()));
  }
  void retrieveUserData()async{
    DataSnapshot dataSnapshot = await usersRef.child(currentfirebaseUser.uid).once();
    Map pazadaProfile = dataSnapshot.value;


setState(() {
  username = pazadaProfile['name'];
});
 }
 void getProfileDetails()async{
   //UserKart =  widget.models.userCart;
   currentfirebaseUser = await FirebaseAuth.instance.currentUser;
   DataSnapshot dataSnapshot = await usersRef.child(userId).once();
   print("=====1111111=============");
   print(usersCurrentInfo.id);
   Map pazadaProfile = dataSnapshot.value;
   setState(() {
     username = pazadaProfile['name'];
     number = pazadaProfile['phone'];
     email = pazadaProfile['email'];
     userName = username;

   });
   print(userName +" "+ number +" "+ email);
 }
}
class SimpleCustomAlert extends StatelessWidget {
  final title;
  SimpleCustomAlert(this.title);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
      ),
      child: Container(
        height: 200,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.white70,
                child: Icon(Icons.account_balance_wallet, size: 60,),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.redAccent,
                child: SizedBox.expand(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        RaisedButton(
                          color: Colors.white,
                          child: Text('Okay'),
                          onPressed: ()=> {
                            Navigator.of(context).pop()
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}