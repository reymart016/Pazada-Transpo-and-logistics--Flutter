import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pazada/models/allUsers.dart';
import 'package:pazada/models/directionDetails.dart';

String mapKey ="AIzaSyAP25tCBApZ2ljRk4JhYPpSDeGYMV4xpz0";

User firebaseUser;
User currentfirebaseUser;
Users usersCurrentInfo;
bool mapbook =false;
bool autoLoc = false;
DirectionDetails tripDirectionDetails;
bool pazshipp = false;
bool pazakayy = false;
String userId = "";
FirebaseAuth auth;