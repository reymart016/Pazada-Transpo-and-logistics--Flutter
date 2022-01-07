

import 'package:cloud_firestore/cloud_firestore.dart';


class PazabuyProducts{
  String menuID;
  String productID;
  String sellerUID;
  String sellerName;
  String productName;
  String productDetails;
  Timestamp publishedDate;
  String thumbnailUrl;
  String status;
  String price;


  PazabuyProducts(
      {this.menuID,
        this.productID,
        this.sellerUID,
        this.sellerName,
        this.productName,
        this.productDetails,
        this.publishedDate,
        this.thumbnailUrl,
        this.status,
        this.price});

  PazabuyProducts.fromJson(Map<String, dynamic> json){

    menuID = json["menuID"];
    productID = json["productID"];
    sellerUID = json["sellerUID"];
    sellerName = json["sellerName"];
    productName = json["productName"];
    productDetails = json["productDetails"];
    publishedDate = json["publishedDate"];
    thumbnailUrl = json["thumbnailUrl"];
    price = json["price"];
    status = json["status"];

  }
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["menuID"] = menuID;
    data["productID"] = productID;
    data["sellerUID"] = sellerUID;
    data["sellerName"] = sellerName;
    data["productName"] = productName;
    data["productDetails"] = productDetails;
    data["publishedDate"] = publishedDate;
    data["thumbnailUrl"] = thumbnailUrl;
    data["price"] = price;
    data["status"] = status;

    return data;
  }
}