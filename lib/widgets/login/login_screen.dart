import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pazada/DialogBox/errorDialog.dart';
import 'package:pazada/bottomBar/bottomAppBar.dart';
import 'package:pazada/configs/Universal_Variable.dart';
import 'package:pazada/main.dart';
import 'package:pazada/widgets/pazada_screen.dart';
import 'package:pazada/widgets/shared/loading.dart';
import 'package:pazada/widgets/shared/screenState.dart';
import 'package:pazada/widgets/signup/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String idScreen = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = new TextEditingController();

  TextEditingController passwordTextEditingController = new TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ?Loading(): Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 150.0,),
            Center(
              child: Image(image: AssetImage("images/pazada-logo.png",
              ),
                width: 80.0,
                height: 120.0,
                alignment: Alignment.center,
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon:Icon(Icons.email),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber), borderRadius: BorderRadius.circular(10)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: "Email",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10.0,
                  ),
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'bolt',
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: passwordTextEditingController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon:Icon(Icons.lock),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber), borderRadius: BorderRadius.circular(10)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: "Password",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10.0,
                  ),
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'bolt',
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            SizedBox(height: 15.0),
            Container(
              width: MediaQuery.of(context).size.width * .96,
              child: RaisedButton(

                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                color: Colors.amber,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Login', style: TextStyle(
                      color: Colors.white,


                    ),

                    ),
                  ),
                ),
                onPressed: (){
                  if(!emailTextEditingController.text.contains("@")){
                    displayToastMessage("Email address is not valid", context);
                  }else if(passwordTextEditingController.text.isEmpty){
                    displayToastMessage("The password is too short", context);
                  }else{
                    signinUser(context);

                  }
                },
              ),
            ),
            SizedBox(height: 170,),
            Text('------------------------------------- or -------------------------------------'),
            SizedBox(height: 10.0),
            Container(
              width: MediaQuery.of(context).size.width * .96,
              child: RaisedButton(

                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                color: Colors.amberAccent,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Signup', style: TextStyle(
                      color: Colors.white,


                    ),

                    ),
                  ),
                ),
                onPressed: (){
                  Navigator.pushNamedAndRemoveUntil(context, SignupScreen.idScreen, (route) => false);
                },
              ),
            )

          ],
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void signinUser(BuildContext context)async{
    final User firebaseUser = (await _firebaseAuth.signInWithEmailAndPassword
      (email: emailTextEditingController.text, password: passwordTextEditingController.text).catchError((errMsg){
      displayToastMessage("Error:" + errMsg.toString(), context);
    }
    )).user;

    if(firebaseUser != null){
      readDataAndSetDataLocally(firebaseUser);
      print(firebaseUser.uid);
      getUserData(firebaseUser.uid);
      setState(() {
        uid = firebaseUser.uid;
        loading = true;
      });

      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap){
        if(snap.value != null){
          print('done');

        }
        else{
          setState(() {
            loading = false;
          });

          _firebaseAuth.signOut();
          displayToastMessage("User doesn't exist, please Signup", context);
        }
      });



    }
    else{
      displayToastMessage("User doesn't exist", context);
    }


  }
  Future readDataAndSetDataLocally(User firebaseUser)async{
    await FirebaseFirestore.instance.collection('PazadaUsers').doc(firebaseUser.uid).get().then((snapshot)async{
    if(snapshot.exists){
      List<String> userCartList = snapshot.data()["userCart"].cast<String>();
      await sharedPreferences.setStringList("userCart", userCartList);
      await sharedPreferences.setString("uId", firebaseUser.uid);
      await sharedPreferences.setString("userName", snapshot.data()["userName"]);
      await sharedPreferences.setString("email", snapshot.data()["email"]);

      print("+++======================+++");
      print(sharedPreferences.getStringList("userCart"));
      print("+++======================+++");
    }else {
      print("+++======================+++");
      print(firebaseUser.uid);
      print("+++======================+++");
      _firebaseAuth.signOut();
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.idScreen, (route) => false);
    }
    });
  }
  getUserData(String uid) async{
    await FirebaseFirestore.instance.collection('PazadaUsers').doc(uid).get().then((results){
      bool status = results.data()['Activated'];
      if(status == true){
        Navigator.pop(context);

        Navigator.pushNamedAndRemoveUntil(context, BottomBar.idScreen, (route) => false);
        displayToastMessage("Mabuhay, your now part of Pazada", context);
      }else{
        _firebaseAuth.signOut();



        showDialog(
            context: context,
            builder: (con){
              return ErrorAlertDialog(
                message: "This account has been blocked by admin. Please contact our helpline",
              ) ;
            });

      }
    });
  }
}
displayToastMessage(String Message, BuildContext context){
  Fluttertoast.showToast(msg: Message);
}
