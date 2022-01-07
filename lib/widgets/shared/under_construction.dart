import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UnderConstruction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40,),

            Text('Page Under Construction', style: TextStyle(fontSize: 22.0, fontFamily: 'Bolt-Bold'),),

            SizedBox(height: 25,),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('please bare with us:)', textAlign: TextAlign.center,style: TextStyle(fontFamily: 'bolt'),),
            ),

            SizedBox(height: 5,),
            Center(
              child: Lottie.asset('assets/lotties/page-construction.json', height:200),
            ),
            SizedBox(height: 30,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: RaisedButton(
                onPressed: ()
                {
                  Navigator.pop(context);
                },
                color: Theme.of(context).accentColor,
                child: Padding(
                  padding: EdgeInsets.all(17.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Go Back", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),
                      Icon(Icons.car_repair, color: Colors.white, size: 26.0,),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),

    );
  }
}
