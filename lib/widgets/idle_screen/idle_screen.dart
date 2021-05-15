import 'package:flutter/material.dart';
import 'package:pazada/testscreen/color.dart';
import 'package:pazada/testscreen/layout.dart';
import 'package:pazada/testscreen/testscreen2.dart';
import 'package:pazada/widgets/pazada_screen.dart';
import 'package:pazada/widgets/pazada_screen/payment_panel.dart';

class IdleScreen extends StatefulWidget {
  static const String idScreen = "idleScreen";
  @override
  _IdleScreenState createState() => _IdleScreenState();
}

class _IdleScreenState extends State<IdleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(

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
                  Padding(
                    padding: const EdgeInsets.only(top: 8,left: 8,right: 12,),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text("Hello, \nReymart D.",style: TextStyle(fontSize: 40, fontFamily: "bolt-bold", color: Colors.white) ,maxLines: 2, ),

                          CircleAvatar(),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Balance",style: TextStyle(fontSize: 15, fontFamily: "bolt-bold", color: Colors.black) ,maxLines: 1, ),
                                Text("Rewards",style: TextStyle(fontSize: 15, fontFamily: "bolt-bold", color: Colors.black) ,maxLines: 1, ),
                                Text("Total Trips",style: TextStyle(fontSize: 15, fontFamily: "bolt-bold", color: Colors.black) ,maxLines: 1, ),
                              ],
                            ),

                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Row(

                              children: [
                                SizedBox(width: 65,),
                                Text("360",style: TextStyle(fontSize: 15, fontFamily: "bolt-bold", color: Colors.black) ,maxLines: 1, ),
                                SizedBox(width:100,),
                                Text("5",style: TextStyle(fontSize: 15, fontFamily: "bolt-bold", color: Colors.black) ,maxLines: 1, ),
                                SizedBox(width: 100,),
                                Text("12",style: TextStyle(fontSize: 15, fontFamily: "bolt-bold", color: Colors.black) ,maxLines: 1, ),
                              ],
                            ),

                          ),
                        )
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
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: spacing / 2),
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: spacing),
                    GestureDetector(
                      onTap: services,
                      child: PazadaCard(
                        color: pazakay,
                        label: "Pazakay",
                        svgPath: 'images/bus.svg',
                      ),
                    ),
                    PazadaCard(
                      color: pazabuy,
                      label: "Pazabuy",
                      svgPath: 'images/train.svg',
                    ),
                    PazadaCard(
                      color: pazship,
                      label: "PazShip",
                      svgPath: 'images/train.svg',
                    ),
                  ],
                ),
              ),
            )
    ]
        ),
      ),
    );
  }
  void services (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> PazadaScreen()));
  }
}
