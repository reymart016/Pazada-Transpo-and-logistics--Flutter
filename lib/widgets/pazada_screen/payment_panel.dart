import 'package:flutter/material.dart';
import 'package:pazada/dataHandler/appData.dart';
import 'package:provider/provider.dart';

class PaymentPanel extends StatefulWidget {

  @override
  _PaymentPanelState createState() => _PaymentPanelState();
}

class _PaymentPanelState extends State<PaymentPanel> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();
  String valueChoose,vehicleChoose;
  List listItem = ["PazPaz", "Willing to Wait"];
  List vehicleItem = ["Trike", "Habal","Padyak"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [Container(
        child: Column(
          children: [
            SizedBox(height: 16,),
            Image.asset("images/delivery.png",height: 250,width: 250,),

            Center(
              child: Container(
                height: 270,
                alignment: Alignment.center,

                width: MediaQuery.of(context).size.width * .96,
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
                child: Padding(
                  padding: EdgeInsets.only(left: 25,top:20,right: 25,bottom: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 5,),
                      Stack(
                        children: [
                          GestureDetector(
                              onTap:(){
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back_ios)),
                          Center(
                            child: Text("Set Drop-Off", style:TextStyle(fontSize: 18,fontFamily: 'bolt-bold')),
                          )
                        ],
                      ),
                      SizedBox(height: 16,),
                      Row(
                        children:[Image.asset("images/pazada-logo.png", height: 16, width: 16,),
                          SizedBox(width: 5,),
                          Expanded(

                            child: Container(

                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(5),

                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                                child: Text(Provider.of<AppData>(context).pickUpLocation!= null
                                        ? Provider.of<AppData>(context).pickUpLocation.placename
                                              : "Add Home", style: TextStyle(fontSize: 15,),maxLines: 2,textAlign: TextAlign.center,
                                           ),
                              ),
                            ),
                          )],
                      ),
                      SizedBox(height: 16,),
                      Row(
                        children: [
                          Image.asset("images/pazada-logo.png", height: 16, width: 16,),
                          SizedBox(width: 5,),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5),

                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal:30, vertical: 6),
                                child: Text(Provider.of<AppData>(context).destinationLocation!= null
                                    ? Provider.of<AppData>(context).destinationLocation.placename
                                    : "Destination", style: TextStyle(fontSize: 15, fontFamily: "bolt"),maxLines: 2,textAlign: TextAlign.center,
                                ),
                            ),
                          ),)],
                      ),
                      SizedBox(height: 16,),
                     Row(
                       children: [

                         Container(

                           width: MediaQuery.of(context).size.width * .40,
                           decoration: BoxDecoration(
                             color: Colors.grey[200],
                             borderRadius: BorderRadius.circular(5),

                           ),
                           child: Padding(
                             padding: const EdgeInsets.symmetric(horizontal:5,),
                             child: DropdownButton(
                               underline: SizedBox(),
                               isExpanded: true,
                               icon: Icon(Icons.arrow_drop_down_circle_outlined),
                               hint: Text("Select Service", style: TextStyle(fontSize: 15, fontFamily: "bolt"),textAlign: TextAlign.center, ),
                               value: valueChoose,
                               onChanged:(newValue){
                                 setState(() {
                                   valueChoose = newValue;
                                 });
                               },
                               items: listItem.map((valueItem){
                                 return DropdownMenuItem(
                                   value: valueItem,
                                   child: Text(valueItem,style: TextStyle(fontSize: 15, fontFamily: "bolt"),textAlign: TextAlign.center,),
                                 );
                               }).toList(),
                             ),
                           ),
                         ),
                         SizedBox(width: 18,),
                         Container(
                           width: MediaQuery.of(context).size.width * .40,
                           decoration: BoxDecoration(
                             color: Colors.grey[200],
                             borderRadius: BorderRadius.circular(5),

                           ),
                           child: Padding(
                             padding: const EdgeInsets.symmetric(horizontal:5,),
                             child: DropdownButton(
                               underline: SizedBox(),
                               isExpanded: true,
                               icon: Icon(Icons.arrow_drop_down_circle_outlined),
                               hint: Text("Select Vehicle",style: TextStyle(fontSize: 15, fontFamily: "bolt"),textAlign: TextAlign.center, ),
                               value: vehicleChoose,
                               onChanged:(vehicleValue){
                                 setState(() {
                                   vehicleChoose = vehicleValue;
                                 });
                               },
                               items: vehicleItem.map((vehicleItem){
                                 return DropdownMenuItem(
                                   value: vehicleItem,
                                   child: Text(vehicleItem,style: TextStyle(fontSize: 15, fontFamily: "bolt"),textAlign: TextAlign.center,),
                                 );
                               }).toList(),
                             ),
                           ),
                         ),
                       ],
                     )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        ),
          Spacer(),
          Spacer(),
          Spacer(),
          Spacer(),

        Expanded(
          flex: 2,
          child: Column(
            children: [

              FlatButton(onPressed: (){
                Navigator.pop(context);
              },
                color: Colors.amber,
                minWidth:MediaQuery.of(context).size.width * .96 ,
                height: 60,
              child: Text("Request", style: TextStyle(fontFamily: "bolt", fontSize:18, color: Colors.white),textAlign: TextAlign.center, ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),

              ),
              )

            ],
          ),
        ),
      ]),

    );
  }
}
