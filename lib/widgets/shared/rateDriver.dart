import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:pazada/bottomBar/bottomAppBar.dart';
import 'package:pazada/configs/Universal_Variable.dart';
import 'package:pazada/widgets/idle_screen/idle_screen.dart';
import 'package:pazada/widgets/pazada_screen.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RateDriver extends StatefulWidget {
  @override
  State<RateDriver> createState() => _RateDriverState();
}

class _RateDriverState extends State<RateDriver> with SingleTickerProviderStateMixin{
  AnimationController lottieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //lottieController = AnimationController(duration: Duration(seconds: 3),vsync: this);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //lottieController.dispose();
  }
  @override

  Widget build(BuildContext context) {
    return Dialog(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Container(
          margin: EdgeInsets.all(0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding:  EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10,),

                  Text('Rate Driver', style: TextStyle(fontSize: 22.0, fontFamily: 'Bolt-Bold'),),

                  SizedBox(height: 5,),


                  SmoothStarRating(
                    rating: starCounter,
                    color: Colors.amber,
                    allowHalfRating: false,
                    starCount: 5,
                    size: 45,
                    onRated: (value){
                      starCounter = value;


                      if(starCounter == 1){
                        setState(() {
                          rateTitle = "Bad Driver";
                        });
                      }
                      if(starCounter == 2){
                        setState(() {
                          rateTitle = "Very Bad";
                        });
                      }
                      if(starCounter == 3){
                        setState(() {
                          rateTitle = "Good";
                        });
                      }
                      if(starCounter == 4){
                        setState(() {
                          rateTitle = "Very Good";
                        });
                      }
                      if(starCounter == 5){
                        setState(() {
                          rateTitle = "Excellent";
                        });
                      }


                    },
                  ),
                  SizedBox(height: 10,),
                  Text(rateTitle, style: TextStyle(fontSize: 22.0, fontFamily: 'Bolt-Bold'),),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: RaisedButton(
                      onPressed: ()
                      {
                        DatabaseReference driverRatingRef = FirebaseDatabase.instance.reference().
                            child("PazadaDrivers").child(driverID).child("ratings");

                        driverRatingRef.once().then((DataSnapshot dataSnapshot){
                          if(dataSnapshot.value != null){
                              double oldRatings = double.parse(dataSnapshot.value.toString());
                              double addRatings = oldRatings + starCounter;
                              double averageRatings = addRatings / 2;
                              driverRatingRef.set(averageRatings.toString());
                          }else{
                            driverRatingRef.set(starCounter.toString());
                          }

                        });

                        Navigator.pop(context);

                      },
                      color: Theme.of(context).accentColor,
                      child: Padding(
                        padding: EdgeInsets.all(17.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Done", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),

                          ],
                        ),
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),

    );
  }
}
