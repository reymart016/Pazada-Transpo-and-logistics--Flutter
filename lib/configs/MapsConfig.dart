import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pazada/models/allUsers.dart';
import 'package:pazada/models/directionDetails.dart';

String mapKey ="AIzaSyCi2plScLf7yEWftiuD_kmApMNbHUFkbsA";

User firebaseUser;
User currentfirebaseUser;
Users usersCurrentInfo;
bool mapbook =false;
bool autoLoc = false;
DirectionDetails tripDirectionDetails;
