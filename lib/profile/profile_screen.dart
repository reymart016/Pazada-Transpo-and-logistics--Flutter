import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pazada/assistants/assistantMethod.dart';
import 'package:pazada/configs/MapsConfig.dart';
import 'package:pazada/configs/Universal_Variable.dart';
import 'package:pazada/main.dart';
import 'package:pazada/travel_history/pazadaRideHistoryScreen.dart';
import 'package:pazada/widgets/login/login_screen.dart';
import 'package:pazada/widgets/shared/progressDialog.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;



  verifyEmail()async{
    if(user != null && !user.emailVerified){
      await user.sendEmailVerification();
      print('Verification Email has been sent');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Verification Email has been sent", style:
          TextStyle(fontSize: 18.0, color: Colors.amber, fontFamily: 'bolt-bold')
            ,)

      ));
    }
  }


  void initState() {
    // TODO: implement initState
    AssistantMethod.getCurrentOnlineInformation();
    getProfileDetails();
    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.white
              ],
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 73),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Icon(
                      //   AntDesign.arrowleft,
                      //   color: Colors.black54,
                      // ),
                      GestureDetector(
                        onTap: (){
                          showDialog(context: context,barrierDismissible: false, builder: (BuildContext context)=> ProgressDialog(message: "Logging Out...."));
                          _signOut();
                          },
                        child: Icon(
                          AntDesign.logout,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'My\nProfile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 34,
                      fontFamily: 'bolt-bold',
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Container(
                    height: height * 0.43,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double innerHeight = constraints.maxHeight;
                        double innerWidth = constraints.maxWidth;
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: innerHeight * 0.72,
                                width: innerWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.amber,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 80,
                                    ),
                                    Text(
                                      usernamee,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'bolt-bold',
                                        fontSize: 37,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Total Trips',
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontFamily: 'bolt',
                                                fontSize: 25,
                                              ),
                                            ),
                                            Text(
                                              size.toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'bolt',
                                                fontSize: 25,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 25,
                                            vertical: 8,
                                          ),
                                          child: Container(
                                            height: 50,
                                            width: 3,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(100),
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'Pending',
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontFamily: 'bolt',
                                                fontSize: 25,
                                              ),
                                            ),
                                            Text(
                                              '1',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'bolt',
                                                fontSize: 25,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          user.emailVerified ?  Positioned(
                            top: 110,
                            right: 20,
                            child: Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 40,
                            ),
                          ):
                          Positioned(
                            top: 110,
                            right: 20,
                            child: TextButton(
                              onPressed:()async{
                               await verifyEmail();
                                print("pressed");
                              },
                              child: Text("Verify Email",style: TextStyle(
                                color: Colors.blue,
                                fontFamily: 'bolt-bold',
                                fontSize: 20,
                              ),),
                            ),
                          )
                            ,
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  child: SvgPicture.asset(
                                    'images/svg/profileTemp.svg',
                                    width: innerWidth * 0.45,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: showRideHistory,
                    child: Container(
                      height: height * 0.23,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.amber,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [


                            SizedBox(
                              height: 20,
                            ),

                            Container(
                              height: height * 0.175,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                            child: Padding(
                            padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SvgPicture.asset('images/svg/angkaswdriver.svg', height: 90,),
                                  Text("Travel History",style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'bolt',
                                    fontSize: 20,
                                  ),),

                                ],
                              ),
                            )
                      ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
  void getProfileDetails()async{
    print("=====CALLED=============");
    print(sharedPreferences.getString("uid"));
    DataSnapshot dataSnapshot = await usersRef.child(_firebaseAuth.currentUser.uid).once();


    Map pazadaProfile = dataSnapshot.value;
    setState(() {
      usernamee = pazadaProfile['name'];
      number = pazadaProfile['phone'];
      email = pazadaProfile['email'];
      userName = usernamee;

    });
    print("||||||||||||||||"+usernamee);
    // get the length of the database
    CollectionReference countRef = FirebaseFirestore.instance.collection("PazadaSellers").doc(sharedPreferences.getString("uid")).collection("History");
    await countRef.get().then((value) {
      setState(() {
        size = value.docs.length;
      });
    });
    print("???????????"+size.toString());

    // get the length of the database
  }
  Future signOut()async{
    Navigator.pop(context);
    auth.signOut().then((c){
      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
    });
  }
  _signOut() async {

    await _firebaseAuth.signOut().then((c){

      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
    });
  }
  void showRideHistory(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PazadaRideHistoryScreen()),
    );
  }
}