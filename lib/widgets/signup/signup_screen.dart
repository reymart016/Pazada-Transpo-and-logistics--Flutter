import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pazada/bottomBar/bottomAppBar.dart';
import 'package:pazada/main.dart';
import 'package:pazada/widgets/login/login_screen.dart';
import 'package:pazada/widgets/pazada_screen.dart';
import 'package:pazada/widgets/shared/bottomNavigationBar.dart';

class SignupScreen extends StatefulWidget {
  static const String idScreen = "signup";

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameTextEditingController = new TextEditingController();

  TextEditingController phoneTextEditingController = new TextEditingController();

  TextEditingController emailTextEditingController = new TextEditingController();

  TextEditingController passwordTextEditingController = new TextEditingController();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50.0,),
            Center(
              child: Image(image: AssetImage("images/pazada-logo.png",
              ),
                width: 80.0,
                height: 120.0,
                alignment: Alignment.center,
              ),
            ),
            SizedBox(height: 6.0),
            Text('Create an Account', style: TextStyle(fontSize: 30,fontFamily: "bolt-bold"),),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: nameTextEditingController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  prefixIcon:Icon(Icons.person),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber), borderRadius: BorderRadius.circular(10)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),

                  labelText: "Fullname",
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
                controller: phoneTextEditingController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon:Icon(Icons.phone_android),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber), borderRadius: BorderRadius.circular(10)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: "+63 | Mobile Number",
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
            SizedBox(height: 5.0),
            Row(
              children: [
                Checkbox(
                value: isChecked,
                onChanged: (bool b){
                  setState(() {
                    isChecked= b;
                  });
                },

              ),
                Text("I have read and accept the Terms & Condition")
            ]),

            Container(
              width: MediaQuery.of(context).size.width * .96,
              child: RaisedButton(

                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                color: Colors.amber,
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

                    if(nameTextEditingController.text.length <= 6 && nameTextEditingController.text != int){
                     displayToastMessage("Your name must be atleast 5 characters", context);
                    }else if(!emailTextEditingController.text.contains("@")){
                      displayToastMessage("Email address is not valid", context);
                    }else if(phoneTextEditingController.text != null && phoneTextEditingController.text.length < 11){
                      displayToastMessage("Your phone number is invalid", context);
                    }else if(passwordTextEditingController.text.isEmpty && passwordTextEditingController.text.length <7){
                      displayToastMessage("The password is too short", context);

                    }
                    else if(isChecked!=true){
                      displayToastMessage("You need to agree to the Terms & Condition!", context);

                    }
                    else{
                      registerNewUser(context);
                    }
                },
              ),
            ),
            SizedBox(height: 70,),
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
                    child: Text('Already have an account?', style: TextStyle(
                      color: Colors.white,


                    ),

                    ),
                  ),
                ),
                onPressed: (){
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                },
              ),
            )

          ],
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async{
    final User firebaseUser = (await _firebaseAuth
        .createUserWithEmailAndPassword
      (email: emailTextEditingController.text, password: passwordTextEditingController.text)
    .catchError((errMsg){
      displayToastMessage("Error:" + errMsg.toString(), context);
    }
    )).user;
    if(firebaseUser != null){

      Map userDatamap = {
        "name" : nameTextEditingController.text,
        "phone": phoneTextEditingController.text,
        "email": emailTextEditingController.text,
      };
      usersRef.child(firebaseUser.uid).set(userDatamap);
      displayToastMessage("Mabuhay, your now part of Pazada", context);
      Navigator.pushNamedAndRemoveUntil(context, BottomBar.idScreen, (route) => false);

    }
    else{
      displayToastMessage("User doesn't exist", context);
    }
  }
}
displayToastMessage(String Message, BuildContext context){
  Fluttertoast.showToast(msg: Message);
}
class CheckBox extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CheckBoxWidget();
    
  }

}

class CheckBoxWidget extends State<CheckBox>{
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CheckBox(

          ),
        ],
      ),
    );
  }

}