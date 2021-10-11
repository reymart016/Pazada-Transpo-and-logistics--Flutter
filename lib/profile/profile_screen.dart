import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pazada/configs/MapsConfig.dart';
import 'package:pazada/main.dart';
import 'package:pazada/models/allUsers.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User currentfirebaseUser;
  //DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("PazadaUsers");
  String username ="";
  String number = "";
  String email = "";


 final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState

    getProfileDetails();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(

          child: Column(
            children: [
              Text(username, style: TextStyle(
                  fontSize: 30, fontFamily: "bolt"
              ),),
              Text(number, style: TextStyle(
                  fontSize: 30, fontFamily: "bolt"
              ),),
              Text(email, style: TextStyle(
                  fontSize: 30, fontFamily: "bolt"
              ),),
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
  void getProfileDetails()async{
    DataSnapshot dataSnapshot = await usersRef.child(currentfirebaseUser.uid).once();

    Map pazadaProfile = dataSnapshot.value;
    setState(() {
      username = pazadaProfile['name'];
      number = pazadaProfile['phone'];
      email = pazadaProfile['email'];
    });
    print(username +" "+ number +" "+ email);
  }
}
