import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pazada/configs/MapsConfig.dart';
import 'package:pazada/dataHandler/appData.dart';
import 'package:pazada/models/allUsers.dart';
import 'package:pazada/user_dashboard/PazadaCard.dart';
import 'package:pazada/user_dashboard/color.dart';
import 'package:pazada/user_dashboard/layout.dart';
import 'package:pazada/widgets/pazabuy_screen/pazabuy_item_list.dart';
import 'package:pazada/widgets/pazabuy_screen/pazabuy_screen.dart';

import 'package:pazada/widgets/pazada_screen.dart';
import 'package:pazada/widgets/pazada_screen/payment_panel.dart';
import 'package:pazada/widgets/pazakay/mode2/pazakay_query2.dart';
import 'package:pazada/widgets/pazakay/pazakay_query.dart';
import 'package:provider/provider.dart';


class IdleScreen extends StatefulWidget {
  static const String idScreen = "idleScreen";
  @override
  _IdleScreenState createState() => _IdleScreenState();
}

class _IdleScreenState extends State<IdleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(

        children: [

          Stack(
          children: [

          Container(
          height: 270,
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
                      Text("Hello \n"+ usersCurrentInfo.name,style: TextStyle(fontSize: 40, fontFamily: "bolt-bold", color: Colors.white) ,maxLines: 2, ),

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
                  height: 80,
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
                                  Text("12",style: TextStyle(fontSize: 20, fontFamily: "bolt-bold", color: Colors.black) ,maxLines: 3,textAlign: TextAlign.center,  ),
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
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: spacing / 2),
                scrollDirection: Axis.vertical,
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
                      onTap: services2,
                      child: PazadaCard(
                        color: pazabuy,
                        label: "Pazabuy",
                        svgPath: 'images/svg/sidetric.svg',
                      ),
                    ),
                    GestureDetector(
                      onTap: services3,
                      child: PazadaCard(
                        color: pazship,
                        label: "PazShip",
                        svgPath: 'images/svg/delman1.svg',
                      ),
                    ),
                  ],
                ),
              ),
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
    Navigator.push(context, MaterialPageRoute(builder: (context)=> PazabuyItem()));
  }
  void services3 (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> PazakayQuery()));
  }
  void services4 (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> PazakayQuery2()));
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