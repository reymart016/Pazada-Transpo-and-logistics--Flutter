
import 'package:cloud_firestore/cloud_firestore.dart';


class PazabuyMenus{
  String menuID;
  String sellerUID;
  String menuName;
  String menuDetails;
  Timestamp publishedDate;
  String thumbnailUrl;
  String status;
  String QRcode;

  PazabuyMenus(
      {this.menuID,
      this.sellerUID,
      this.menuName,
      this.menuDetails,
      this.publishedDate,
      this.thumbnailUrl,
      this.status,
      this.QRcode
      });

  PazabuyMenus.fromJson(Map<String, dynamic> json){

    menuID = json["menuID"];
    sellerUID = json["sellerUID"];
    menuName = json["menuName"];
    menuDetails = json["menuDetails"];
    publishedDate = json["publishedDate"];
    thumbnailUrl = json["thumbnailUrl"];
    status = json["status"];
    QRcode = json["QRcode"];

  }
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["menuID"] = menuID;
    data["sellerUID"] = sellerUID;
    data["menuName"] = menuName;
    data["menuDetails"] = menuDetails;
    data["publishedDate"] = publishedDate;
    data["thumbnailUrl"] = thumbnailUrl;
    data["status"] = status;
    data["QRcode"] = QRcode;

    return data;
  }
}