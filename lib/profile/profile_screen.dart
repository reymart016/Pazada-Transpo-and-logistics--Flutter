import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pazada/configs/MapsConfig.dart';
import 'package:pazada/models/allUsers.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Users _users = Users();
 final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(

          child: Column(
            children: [
              Center(
                child: Text(
                  "Username", style: TextStyle(
                  fontFamily: 'bolt-bold',fontSize: 20
                ),
                ),
              ),
              FlatButton(onPressed: ()async{

                await auth.signOut();

              },
                color: Colors.amber,
                minWidth:MediaQuery.of(context).size.width * .96 ,
                height: 60,
                child: Text("Sign-out", style: TextStyle(fontFamily: "bolt", fontSize:18, color: Colors.white),textAlign: TextAlign.center, ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),

                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
