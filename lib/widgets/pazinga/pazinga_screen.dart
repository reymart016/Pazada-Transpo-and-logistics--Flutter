import 'package:flutter/material.dart';
import 'package:pazada/widgets/shared/divider.dart';

class Pazinga extends StatefulWidget {
  @override
  _PazingaState createState() => _PazingaState();
}

class _PazingaState extends State<Pazinga> {
  @override
  Widget build(BuildContext context) {
    return Container(

     child: Column(
       children:[
         Padding(
           padding: const EdgeInsets.only(top:60.0,left: 8,right: 8),
           child: Text("PAZINGA", style: TextStyle(color: Colors.amber, fontSize: 30, fontFamily: "bolt-bold"),),
         ),

         Center(


          child: Padding(
            padding: const EdgeInsets.all(8.0),

            child: Container(


              width: MediaQuery.of(context).size.width,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 3,
                        spreadRadius: .8,
                        offset: Offset(
                            1,3
                        )
                    )
                  ]
              ),

            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Center(
                      child: Row(
                        children: [
                          SizedBox(width: 40,),
                          Image.asset("images/PAZINGA.png", height:  80,width: 80,),
                          SizedBox(width: 20,),
                          Text("365.00", style: TextStyle(fontSize: 50,fontFamily: "bolt"),)
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:15.0),
                    child: DividerWidget(),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 70.0),
                    child: Row(
                      children: [

                        Icon(Icons.account_balance_wallet, color: Colors.amber,size: 80,),
                        SizedBox(width: 110,),
                        Icon(Icons.compare_arrows_rounded, color: Colors.amber,size: 80,),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:70.0),
                    child: Row(
                      children: [

                        Text("Top-Up", style: TextStyle(fontSize: 20, color: Colors.amber,fontFamily: "bolt",),),
                        SizedBox(width: 110,),
                        Text("Cash-Out", style: TextStyle(fontSize: 20, color: Colors.amber,fontFamily: "bolt"),),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 70.0),
                    child: Row(
                      children: [

                        Icon(Icons.qr_code_scanner_rounded, color: Colors.amber,size: 80,),
                        SizedBox(width: 110,),
                        Icon(Icons.history_rounded, color: Colors.amber,size: 80,),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:70.0),
                    child: Row(
                      children: [

                        Text("Pay-QR", style: TextStyle(fontSize: 20, color: Colors.amber,fontFamily: "bolt"),),
                        SizedBox(width: 120,),
                        Text("History", style: TextStyle(fontSize: 20, color: Colors.amber,fontFamily: "bolt"),),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            ),
          ),
        ),
       ]
     ),
    );
  }
}
