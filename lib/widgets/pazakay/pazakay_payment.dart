import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pazada/assistants/assistantMethod.dart';
import 'package:pazada/dataHandler/appData.dart';
import 'package:pazada/models/directionDetails.dart';
import 'package:provider/provider.dart';

class PazakayPayment extends StatefulWidget {
  @override
  _PazakayPaymentState createState() => _PazakayPaymentState();
}
List payments = ["Cash", "Gcash (Coming Soon)"];
String paymentChoose;
Position currentPosition,desPosition;

List<LatLng> pLinesCoordinates = [];
Set<Polyline> polylineSet = {};
Set<Marker> markersSet = {};
Set<Circle> circleSet = {};

DirectionDetails tripDirectionDetails;

DatabaseReference rideRequestRef;
class _PazakayPaymentState extends State<PazakayPayment> {
  @override
  Widget build(BuildContext context) {
    return Container(

      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text("Review your Booking", style: TextStyle(fontSize: 20, fontFamily: "bolt-bold"),),

        ),

      body: Stack(
          alignment: Alignment.center,
        children:[
          Positioned(
            left: 0.0,
            right: 0.0,
            top: 0.0,
            child: GestureDetector(
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                height: MediaQuery.of(context).size.height/1.4,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                    // boxShadow:[
                    //   BoxShadow(
                    //     color: Colors.black,
                    //     blurRadius: 16,
                    //     spreadRadius: .5,
                    //     offset: Offset(.7, .7),
                    //   )
                    // ]
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [



                      SizedBox(height: 16.0,),

                      Container(
                        height: 130,
                        width: double.infinity,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 3,color: Colors.amber),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top:10.0, bottom: 10, right: 20, left: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Padding(
                                padding: const EdgeInsets.only(top:5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Trike",style: TextStyle(fontFamily: "bolt-bold",fontSize: 30, color: Colors.amber),
                                    ),
                                    Text("Affordable ride for every Juan. \nMax Capacity: 4 people.",style:TextStyle(fontFamily: "bolt",fontSize: 17)),
                                    SizedBox(height: 10,),
                                    Container(child: Row(
                                      children: [
                                        Icon(Icons.speed,color: Colors.grey,size: 12,),
                                        SizedBox(width: 5,),
                                        Text("0.5 x 0.4 x 0.5 Meter. Up to 4 people", style: TextStyle(fontFamily: "bolt",fontSize: 12, color: Colors.grey),)
                                      ],
                                    ),)
                                  ],

                                ),
                              ),

                              SvgPicture.asset('images/svg/trikeA.svg',height: 50,),

                            ],

                          ),
                        ),
                      ),
                      SizedBox(height: 10,),

                      // Container(
                      //   width: MediaQuery.of(context).size.width * .96,
                      //   decoration: BoxDecoration(
                      //     color: Colors.grey[200],
                      //     borderRadius: BorderRadius.circular(5),
                      //
                      //   ),
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal:5,),
                      //     child: DropdownButton(
                      //
                      //       underline: SizedBox(),
                      //       isExpanded: true,
                      //       icon: Icon(Icons.arrow_drop_down_circle_outlined),
                      //       hint: Text("Select Payment",style: TextStyle(fontSize: 15, fontFamily: "bolt"),textAlign: TextAlign.center, ),
                      //       value: paymentChoose,
                      //       onChanged:(paymentValue){
                      //         setState(() {
                      //           paymentChoose = paymentValue;
                      //         });
                      //       },
                      //       items: payments.map((vehicleItem){
                      //         return DropdownMenuItem(
                      //
                      //           value: vehicleItem,
                      //           child: Text(vehicleItem,style: TextStyle(fontSize: 15, fontFamily: "bolt"),textAlign: TextAlign.center,),
                      //         );
                      //       }).toList(),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 10,),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(

                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Origin:', style: TextStyle(fontFamily: "bolt",fontSize: 11),),
                                      SizedBox(height: 10,),
                                      Text('Destination:', style: TextStyle(fontFamily: "bolt",fontSize: 11),),
                                      SizedBox(height: 10,),
                                      Text('Distance:', style: TextStyle(fontFamily: "bolt",fontSize: 11),),
                                      SizedBox(height: 10,),
                                      Text('Succeeding Kilometer:', style: TextStyle(fontFamily: "bolt",fontSize: 11),),
                                    ],
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(Provider.of<AppData>(context).destinationLocation2!= null
                                            ?  Provider.of<AppData>(context).destinationLocation2.placename
                                            : Provider.of<AppData>(context).pickUpLocation!= null
                                            ? Provider.of<AppData>(context).pickUpLocation.placename
                                            : "Add Home", style: TextStyle(fontSize: 11, fontFamily: "bolt"),maxLines: 1,textAlign: TextAlign.left, overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 10,),
                                        Text(Provider.of<AppData>(context).destinationLocation!= null
                                            ? Provider.of<AppData>(context).destinationLocation.placename
                                            : "Destination", style: TextStyle(fontSize: 11, fontFamily: "bolt"),maxLines: 1,textAlign: TextAlign.left, overflow: TextOverflow.ellipsis
                                        ),
                                        SizedBox(height: 10,),
                                        Text(((tripDirectionDetails != null)? tripDirectionDetails.distanceText : ''),style: TextStyle(fontFamily: "bolt",fontSize: 11),
                                        ),
                                        SizedBox(height: 10,),

                                        Text('N/A', style: TextStyle(fontFamily: "bolt",fontSize: 11),),
                                      ],

                                    ),
                                  )
                                ],
                              ),

                            ],
                          ),
                        ),
                      ),
                      // SizedBox(height: MediaQuery.of(context).size.height/4),
                      // Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Container(
                      //         height: 55,
                      //         width: MediaQuery.of(context).size.width * .885,
                      //         child: RaisedButton(
                      //
                      //           shape: new RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(5.0)),
                      //           color: Colors.amber,
                      //           child: Container(
                      //             child: Padding(
                      //               padding: const EdgeInsets.symmetric(vertical: 10),
                      //               child: Text('Confirm', style: TextStyle(
                      //                 color: Colors.white,
                      //
                      //
                      //               ),
                      //
                      //               ),
                      //             ),
                      //           ),
                      //           onPressed: ()async{
                      //
                      //             print('PRESSED');
                      //             setState(() {
                      //               // destinationContainer =0;
                      //               // loadingRider = 280;
                      //             });
                      //           },
                      //         ),
                      //       ),
                      //       // Container(
                      //       //   width: MediaQuery.of(context).size.width * .43,
                      //       //   child: RaisedButton(
                      //       //
                      //       //     shape: new RoundedRectangleBorder(
                      //       //         borderRadius: BorderRadius.circular(5.0)),
                      //       //     color: Colors.red,
                      //       //     child: Container(
                      //       //       child: Padding(
                      //       //         padding: const EdgeInsets.symmetric(vertical: 10),
                      //       //         child: Text('Cancel', style: TextStyle(
                      //       //           color: Colors.white,
                      //       //
                      //       //
                      //       //         ),
                      //       //
                      //       //         ),
                      //       //       ),
                      //       //     ),
                      //       //     onPressed: (){
                      //       //       Navigator.pop(context);
                      //       //     },
                      //       //   ),
                      //       // ),
                      //     ] ),
                    ],

                  ),
                ),
              ),
            ),
          ),
          SizedBox.expand(
            child: DraggableScrollableSheet(
              initialChildSize: .23,
              minChildSize: .23,
              maxChildSize: .23,
              builder: (BuildContext c, s){
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft:  Radius.circular(10),

                    ),
                    boxShadow: [BoxShadow(
                      color: Colors.grey,
                      blurRadius: 18,

                    )]
                  ),
                  child: ListView(
                    controller: s,
                    children: [
                      Center(
                        child: Container(
                          height: 8,
                          width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(5)
                        ),

                        ),

                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[ Text("Total"),
                          Text(((tripDirectionDetails != null)? '\PHP: ${AssistantMethod.calculateFares(tripDirectionDetails)}' : ''),style: TextStyle(fontFamily: "bolt",fontSize: 30,),
                          textAlign: TextAlign.right,
                        ),]
                      ),
                      SizedBox(height: 20,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width * .92,
                              child: RaisedButton(

                                shape: new RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                color: Colors.amber,
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Text('Confirm', style: TextStyle(
                                      color: Colors.white,


                                    ),

                                    ),
                                  ),
                                ),
                                onPressed: ()async{

                                  print('PRESSED');
                                  setState(() {
                                    // destinationContainer =0;
                                    // loadingRider = 280;
                                  });
                                },
                              ),
                            ),

                          ] ),
                    ],
                  ),
                );
              },
            ),
          ),

        ]


      ),
      ),
    );

}
  Future <void> getPlaceDirection()async{
    var initialPos = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).destinationLocation;
    var pickupLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var destinationLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    //showDialog(context: context, builder: (BuildContext context)=> ProgressDialog(message: "Please wait...."));

    var details = await AssistantMethod.obtainPlaceDirectionDetails(pickupLatLng, destinationLatLng);
    setState(() {
      tripDirectionDetails = details;
    });
    //Navigator.pop(context);

    print("This is encoded Points::");
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List <PointLatLng> decodedPolylinePointsResult = polylinePoints.decodePolyline(details.encodedPoints);
    pLinesCoordinates.clear();
    if(decodedPolylinePointsResult.isNotEmpty){
      decodedPolylinePointsResult.forEach((PointLatLng pointLatLng) {
        pLinesCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: Colors.amber,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLinesCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polylineSet.add(polyline);
    });
    // LatLngBounds latLngBounds;
    // if(pickupLatLng.latitude > destinationLatLng.latitude && pickupLatLng.longitude > destinationLatLng.longitude){
    //   latLngBounds = LatLngBounds(southwest: destinationLatLng, northeast: pickupLatLng);
    //
    // }
    // else if(pickupLatLng.longitude > destinationLatLng.longitude){
    //   latLngBounds = LatLngBounds(southwest: LatLng(pickupLatLng.latitude, destinationLatLng.longitude), northeast: LatLng(destinationLatLng.latitude, pickupLatLng.longitude));
    //
    // }
    // else if(pickupLatLng.latitude > destinationLatLng.latitude){
    //   latLngBounds = LatLngBounds(southwest: LatLng(destinationLatLng.latitude, pickupLatLng.longitude), northeast: LatLng(pickupLatLng.latitude, destinationLatLng.longitude));
    //
    // }else{
    //   latLngBounds = LatLngBounds(southwest: pickupLatLng, northeast: destinationLatLng);
    // }
    // newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickupMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow: InfoWindow(title: initialPos.placename, snippet: "Your Location!"),
      position: pickupLatLng,
      markerId: MarkerId("pickupID"),

    );
    setState(() {
      markersSet.add(pickupMarker);
    });
    Circle pickupCircle = Circle(
        fillColor: Colors.amber,
        center: pickupLatLng,
        radius:12,
        strokeColor: Colors.amber,
        strokeWidth: 4,
        circleId: CircleId("pickupID")
    );
    Circle destinationCircle = Circle(
        fillColor: Colors.amber,
        center: destinationLatLng,
        radius:12,
        strokeColor: Colors.amber,
        strokeWidth: 4,
        circleId: CircleId("destinationID")
    );
    setState(() {
      circleSet.add(pickupCircle);
      circleSet.add(destinationCircle);
    });
  }
}

