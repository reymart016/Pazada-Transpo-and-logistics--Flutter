

import 'package:cloud_firestore/cloud_firestore.dart';


class PazabuyUsers{
  String UID;

  String userName;
  String email;

  Timestamp publishedDate;
  String thumbnailUrl;
  String status;
  String userNumber;
  List<String> userCart;


  PazabuyUsers(
      {this.UID,

        this.userName,
        this.email,

        this.publishedDate,
        this.thumbnailUrl,
        this.status,
        this.userNumber,
        this.userCart

      });

  PazabuyUsers.fromJson(Map<String, dynamic> json){

    UID = json["uId"];

    userName = json["userName"];
    email = json["email"];

    publishedDate = json["publishedDate"];
    thumbnailUrl = json["thumbnailUrl"];
    userNumber = json["price"];
    status = json["status"];
    userCart = json['userCart'];

  }
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["uId"] = UID;
    data["userName"] = userName;
    data["email"] = email;
    data["userCart"] = userCart;

    data["publishedDate"] = publishedDate;
    data["thumbnailUrl"] = thumbnailUrl;
    data["price"] = userNumber;
    data["status"] = status;

    return data;
  }
}