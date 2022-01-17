import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pazada/models/allUsers.dart';
import 'package:pazada/models/directionDetails.dart';

String mapKey ="AIzaSyBFzp-ExtDMJ3H4Es_ghxOlv1NdFzEi6Bk";

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