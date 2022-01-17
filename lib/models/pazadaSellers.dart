// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';


class PazadaSellers{

  String uId;
  String userName;
  String userNumber;
  Timestamp publishedDate;
  String thumbnailUrl;
  String status;
  String location;

  PazadaSellers(
      {
        this.uId,
        this.userName,
        this.userNumber,
        this.publishedDate,
        this.thumbnailUrl,
        this.status,
        this.location
      });

  PazadaSellers.fromJson(Map<String, dynamic> json){


    uId = json["uId"];
    userName = json["sellerName"];
    userNumber = json["sellerNumber"];
    publishedDate = json["publishedDate"];
    thumbnailUrl = json["thumbnailUrl"];
    status = json["status"];
    location = json["location"];

  }
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();

    data["sellerUID"] = uId;
    data["sellerName"] = userName;
    data["sellerNumber"] = userNumber;
    data["publishedDate"] = publishedDate;
    data["thumbnailUrl"] = thumbnailUrl;
    data["status"] = status;
    data["location"] = location;

    return data;
  }
}