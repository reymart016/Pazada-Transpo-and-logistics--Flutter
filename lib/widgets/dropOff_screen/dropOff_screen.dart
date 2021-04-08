import 'package:flutter/material.dart';
import 'package:pazada/assistants/requestAssistants.dart';
import 'package:pazada/configs/MapsConfig.dart';
import 'package:pazada/dataHandler/appData.dart';
import 'package:pazada/models/placePrediction.dart';
import 'package:pazada/widgets/shared/divider.dart';
import 'package:provider/provider.dart';

class DropOff extends StatefulWidget {
  @override
  _DropOffState createState() => _DropOffState();
}

class _DropOffState extends State<DropOff> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();
  List <PlacePrediction> placePredictionList = [];
  @override
  Widget build(BuildContext context) {
    String placeAddress = Provider.of<AppData>(context).pickUpLocation.placename?? "";
    pickUpTextEditingController.text = placeAddress;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(
                color: Colors.grey,
                blurRadius: 6,
                spreadRadius: .5,
                offset: Offset(7,7)
              )]
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 25,top: 20,right: 25,bottom: 20),
              child: Column(
                children: [
                  SizedBox(height: 15,),
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
                        padding: EdgeInsets.all(3),
                        child: TextField(
                          controller: pickUpTextEditingController,
                          decoration: InputDecoration(
                            hintText: "Pickup Location",
                            fillColor: Colors.grey[200],
                            filled: true,
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.only(left: 11, top: 8, bottom: 8)
                          ),
                        ),
                      ),
                  ),
                    )],
                  ),
                  SizedBox(height: 16,),
                  Row(
                    children: [Image.asset("images/pazada-logo.png", height: 16, width: 16,),
                      SizedBox(width: 5,),
                      Expanded(
                        child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5),

                        ),
                        child: Padding(
                          padding: EdgeInsets.all(3),
                          child: TextField(
                            onChanged: (val){
                              findPlace(val);
                            },
                            controller: dropOffTextEditingController,
                            decoration: InputDecoration(
                                hintText: "Drop-Off Location",
                                fillColor: Colors.grey[100],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 11, top: 8, bottom: 8)
                            ),
                          ),
                        ),
                    ),
                      )],
                  )
                ],
              ),
            ),
          ),
          //tiles for predictions

          (placePredictionList.length>0)? Padding(padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListView.separated(padding: EdgeInsets.all(0 ),
            itemBuilder: (context,index){
            return PredictionTile(placePrediction: placePredictionList[index],);
          },
          separatorBuilder: (BuildContext context, int index)=> DividerWidget(),
            itemCount: placePredictionList.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
          ),
          )


              :
              Container()
        ],
      ),
    );
  }
  void findPlace(String placeName)async{
    if(placeName.length > 1){
      String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=1600+Amphitheatre$placeName&key=$mapKey&sessiontoken=1234567890&components=country:ph";

      var res = await RequestAssistant.getRequest(autoCompleteUrl);

      if(res == "failed"){
        return;
      }
     if(res["status"]=="OK"){
       var predictions = res["predictions"];
       var placeList = (predictions as List).map((e)=>PlacePrediction.fromJson(e)).toList();
       setState(() {

         placePredictionList = placeList;
       });
     }
    }
  }
}
class PredictionTile extends StatelessWidget {
  final PlacePrediction placePrediction;
  PredictionTile({Key key, this.placePrediction}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(width: 10,),
          Row(
            children: [
              Icon(Icons.add_location_alt_outlined),
              SizedBox(width: 14,),
              Expanded(
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2,),
                      Text(placePrediction.main_text,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 2,),
                      Text(placePrediction.secondary_text,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.grey)),
                      SizedBox(height: 2,),
                    ],
                  ))
            ],
          ),
          SizedBox(width: 10,)
        ]
      ),
    );
  }
}

