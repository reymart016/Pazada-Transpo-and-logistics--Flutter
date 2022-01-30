import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:pazada/DialogBox/errorDialog.dart';

import 'package:pazada/bottomBar/bottomAppBar.dart';
import 'package:pazada/configs/Universal_Variable.dart';
import 'package:pazada/main.dart';
import 'package:pazada/widgets/login/login_screen.dart';
import 'package:pazada/widgets/pazada_screen.dart';
import 'package:pazada/widgets/shared/TNC.dart';
import 'package:pazada/widgets/shared/bottomNavigationBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String imageDownloadURLs = "";
  bool uploading = false;
  String uniqueID = DateTime.now().millisecondsSinceEpoch.toString();
  File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        reverse: true,
        shrinkWrap: true,
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
            Center(child: Text('Create an Account', style: TextStyle(fontSize: 30,fontFamily: "bolt-bold"),)),
            SizedBox(height: 6.0),
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
                Row(children: [Text("I have read and accept the "),
                  GestureDetector(onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> TermsAndCondition()));
                  },
                      child: Text("Terms & Condition",style: TextStyle(color: Colors.lightBlueAccent),))

                ])
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
                      //_register();
                      //uploadNewProduct();
                      registerNewUser(context);
                    }
                },
              ),
            ),
            SizedBox(height: 10.0),
            Center(child: Text('------------------------------------- or -------------------------------------')),
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

          ].reversed.toList(),

      ),
    );
  }
  // uploadImage(context){
  //   return showDialog(context: context, builder: (con){
  //     return SimpleDialog(
  //       title: Text("Product Image", style: TextStyle(fontFamily: "bolt", fontSize:18, color: Colors.black),textAlign: TextAlign.center,),
  //       children: [
  //         SimpleDialogOption(
  //           child: Text("Camera", style: TextStyle(fontFamily: "bolt", fontSize:18, color: Colors.black)),
  //           onPressed: capturePhotoWithCamera,
  //         ),
  //         SimpleDialogOption(
  //           child: Text("Gallery", style: TextStyle(fontFamily: "bolt", fontSize:18, color: Colors.black)),
  //           onPressed: capturePhotoWithGallery,
  //         ),
  //         SimpleDialogOption(
  //           child: Text("Cancel", style: TextStyle(fontFamily: "bolt", fontSize:18, color: Colors.redAccent),textAlign: TextAlign.end,),
  //           onPressed: (){
  //             Navigator.pop(context);
  //           },
  //         ),
  //       ],
  //     );
  //   });
  // }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User currentUser;
  void _register() async{


    await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim()
    ).then((auth){
      currentUser = auth.user;
      userID = currentUser.uid;
      userEmail = currentUser.email;
      getUserName = nameTextEditingController.text.trim();

      saveUserData();

    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context, builder: (con){
        return ErrorAlertDialog(
          message: error.message.toString(),
        );
      });
    });

    if(currentUser != null){
      Navigator.pushNamedAndRemoveUntil(context, BottomBar.idScreen, (route) => false);
    }

  }
  void saveUserData(){
    Map userDatamap = {
      "name" : nameTextEditingController.text,
      "phone": phoneTextEditingController.text,
      "email": emailTextEditingController.text,
    };
    usersRef.child(currentUser.uid).set(userDatamap);
    displayToastMessage("Mabuhay, your now part of Pazada", context);

    Map<String, dynamic> userData = {
      'userName': nameTextEditingController.text.trim(),
      'uId': currentUser.uid,
      'userNumber': phoneTextEditingController.text.trim(),

      'time': DateTime.now(),
      'Activated': true,
    };

    FirebaseFirestore.instance.collection('PazadaUsers').doc(userID).set(userData);

  }
  /// IMAGE UPLOAD
  // capturePhotoWithCamera()async{
  //
  //   Navigator.pop(context);
  //   final imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
  //   final imageTemporary = File(imageFile.path);
  //
  //   setState(() {
  //     this.file = imageTemporary;
  //   });
  // }
  // capturePhotoWithGallery()async{
  //   Navigator.pop(context);
  //   final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   final imageTemporary = File(imageFile.path);
  //
  //   setState(() {
  //     this.file = imageTemporary;
  //   });
  // }
  // uploadNewProduct()async{
  //
  //
  //   String imageDownloadURL = await uploadProductImage(file);
  //   setState(() {
  //     imageDownloadURLs = imageDownloadURL;
  //     uploading = true;
  //   });
  //   registerNewUser(context);
  //
  //   print("=================================================");
  //   print(imageDownloadURL);
  //   print("=================================================");
  // }
  // Future <String>  uploadProductImage(file)async{
  //
  //   final Reference productImage = FirebaseStorage.instance.ref().child('Products'); // deprecated FirebaseReference
  //   UploadTask uploadTask = productImage.child("product_$uniqueID.jpg").putFile(file);
  //   TaskSnapshot taskSnapshot = await uploadTask.whenComplete((){
  //
  //   });
  //   String downloadURL = await taskSnapshot.ref.getDownloadURL();
  //   return downloadURL;
  //
  // }

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
      Map<String, dynamic> userData = {
        'userName': nameTextEditingController.text.trim(),
        'uId': firebaseUser.uid,
        "email": emailTextEditingController.text.trim(),
        'userNumber': phoneTextEditingController.text.trim(),
        "thumbnailUrl": imageDownloadURLs,
        'time': DateTime.now(),
        'Activated': true,
        "userCart": ['garbageValue'],
      };

      FirebaseFirestore.instance.collection('PazadaUsers').doc(firebaseUser.uid).set(userData);
      sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString("uId", firebaseUser.uid);
      await sharedPreferences.setString("userName",  nameTextEditingController.text.trim());
      await sharedPreferences.setString("userEmail",  nameTextEditingController.text.trim());
      await sharedPreferences.setStringList("userCart",  ['garbageValue']);
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